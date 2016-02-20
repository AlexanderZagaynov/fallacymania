require 'open-uri'
require 'base64'
require 'json'
require 'date'

class FallaciesDownloader
  TMP_DIR = Rails.root / 'tmp'
  YML_DIR = Rails.root / 'db' / 'seeds'

  GITHUB_API_HOST    = 'api.github.com'
  GITHUB_API_HEADERS = { 'Accept' => 'application/vnd.github.v3+json' }

  USER = 'ub'
  REPO = 'rhetological-fallacies-Russian'
  FILE = 'text/translation.txt'

  REPO_PATH = "/repos/#{USER}/#{REPO}"
  CONTENT_PATH = "#{REPO_PATH}/contents/#{FILE}"
  COMMITS_PATH = "#{REPO_PATH}/commits"
  COMMITS_QUERY = URI.encode_www_form page: 1, per_page: 1, path: FILE

  def download
    return unless (data = read path: CONTENT_PATH).is_a?(Hash)
    return unless data['type'] == 'file' && data['encoding'] == 'base64'

    filename = TMP_DIR / "#{DateTime.now.strftime '%F-%H-%M-%S'}.#{data['sha']}.fallacies.txt"
    File.write filename, Base64.decode64(data['content']).force_encoding('utf-8')

    filename
  end

  private

  def read **options
    JSON.parse URI::HTTPS.build(host: GITHUB_API_HOST, **options).read(GITHUB_API_HEADERS)
  end

  def latest_commit
    info = read path: COMMITS_PATH, query: COMMITS_QUERY
    info&.first&.[]('sha')
  end
end

desc 'Download fallacies into the seeds file'
task 'download:fallacies' do
  puts FallaciesDownloader.new.download
end
