require 'pathname'
require 'open-uri'
require 'base64'
require 'json'
require 'yaml'
require 'time'

class FallaciesDownloader
  GITHUB_API_HOST    = 'api.github.com'
  GITHUB_API_HEADERS = { 'Accept' => 'application/vnd.github.v3+json' }

  USER = 'ub'
  REPO = 'rhetological-fallacies-Russian'
  FILE = 'text/translation.txt'

  REPO_PATH     = "/repos/#{USER}/#{REPO}"
  CONTENT_PATH  = "#{REPO_PATH}/contents/#{FILE}"
  COMMITS_PATH  = "#{REPO_PATH}/commits"
  COMMITS_QUERY = URI.encode_www_form page: 1, per_page: 1, path: FILE

  APP_ROOT = Pathname.new File.expand_path '../../..', __FILE__ # Rails.root
  YML_FILE = APP_ROOT / 'db' / 'seeds' / 'fallacies.yml'
  TMP_DIR  = APP_ROOT / 'tmp'
  TMP_EXT  = '.fallacies.txt'
  TMP_DATE = '%Y%m%d-%H%M%S'
  TMP_GLOB = TMP_DIR / "*#{TMP_EXT}"

  module YAML::Time
    FORMAT = '%Y-%m-%d %H:%M:%S Z'.freeze
    def encode_with coder
      coder.tag = nil
      coder.scalar = getutc.strftime FORMAT
    end
  end

  def self.tmp_files
    Pathname.glob(TMP_GLOB).sort
  end

  def update offline = true #false
    git_sha, git_date = git_info unless offline
    tmp_sha, tmp_date = tmp_info

    new_info = offline ? [tmp_sha, tmp_date] : [git_sha, git_date]
    return if new_info.any?(&:nil?) || new_info == yml_info
    download git_sha, git_date unless offline || git_sha == tmp_sha

    data = %w(abc def) # parse
    new_info = { 'sha' => new_info.shift, 'date' => new_info.shift.extend(YAML::Time) }

    YAML.dump_stream new_info, *data
  end

  private

  def get **options
    JSON.parse URI::HTTPS.build(host: GITHUB_API_HOST, **options).read(GITHUB_API_HEADERS)
  end

  def git_info
    data = get(path: COMMITS_PATH, query: COMMITS_QUERY)&.first
    [data['sha'], Time.parse(data.dig *%w|commit committer date|).utc] if data.is_a? Hash
  end

  def yml_info
    return unless YML_FILE.file?
  end

  def tmp_info
    return unless (parts = tmp_file&.basename(TMP_EXT).to_s.split '.')&.size == 2
    date_parts = Date._strptime(parts.shift, TMP_DATE).values_at *%i(year mon mday hour min sec)
    [parts.shift, Time.utc(*date_parts)]
  end

  def tmp_file
    @tmp_file ||= self.class.tmp_files.last
  end

  def download git_sha, git_date
    data = get path: CONTENT_PATH, query: URI.encode_www_form(ref: git_sha)
    return unless data&.values_at *%w(type encoding) == %w(file base64)

    filename = TMP_DIR / "#{git_date.strftime TMP_DATE}.#{git_sha}#{TMP_EXT}"
    File.write filename, Base64.decode64(data['content']).force_encoding('utf-8')

    @tmp_file = filename
  end
end

namespace :seeds do

  desc 'Update seed data files'
  task :update do
    str = FallaciesDownloader.new.update
    puts str, YAML.load_stream(str).inspect
  end

  desc 'Remove old temporary seed files'
  task :clobber do
  end

  desc 'Remove all temporary seed files'
  task :clean do
  end

end
