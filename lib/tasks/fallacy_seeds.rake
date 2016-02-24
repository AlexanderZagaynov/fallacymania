module FallacySeeds
  module_function

  def update offline = false
    git_sha, git_date = git_info unless offline
    tmp_sha, tmp_date = tmp_info

    new_info = offline ? [tmp_sha, tmp_date] : [git_sha, git_date]

    return 'Can\'t check for updated source' if new_info.any? &:nil?
    return 'Already up to date!'             if new_info == yml_info

    download git_sha, git_date unless offline || git_sha == tmp_sha

    new_info = { sha: new_info.shift, date: new_info.shift.extend(EncodeTime) }
    YML_FILE.write YAML.dump_stream *([new_info] + parse_file).map(&:deep_stringify_keys!)

    YML_FILE.to_path
  end

  private
  module_function

  # github api

  GITHUB_API_HOST    = 'api.github.com'
  GITHUB_API_HEADERS = { 'Accept' => 'application/vnd.github.v3+json' }

  def get **options
    JSON.parse URI::HTTPS.build(host: GITHUB_API_HOST, **options).read(GITHUB_API_HEADERS)
  end

  # source repo

  USER = 'ub'
  REPO = 'rhetological-fallacies-Russian'
  FILE = 'text/translation.txt'

  REPO_PATH     = "/repos/#{USER}/#{REPO}"
  CONTENT_PATH  = "#{REPO_PATH}/contents/#{FILE}"
  COMMITS_PATH  = "#{REPO_PATH}/commits"
  COMMITS_QUERY = { page: 1, per_page: 1, path: FILE }.to_query

  def git_info
    puts 'Asking source repo for updates...'
    data = get(path: COMMITS_PATH, query: COMMITS_QUERY)&.first
    [data['sha'], Time.parse(data.dig *%w|commit committer date|).utc] if data.is_a? Hash
  end

  def download git_sha, git_date
    puts 'Downloading source file...'

    data = get path: CONTENT_PATH, query: { ref: git_sha }.to_query
    return unless data&.values_at *%w(type encoding) == %w(file base64)

    filename = TMP_DIR / "#{git_date.strftime TMP_DATE}.#{git_sha}#{TMP_EXT}"
    File.write filename, Base64.decode64(data['content']).force_encoding('utf-8')

    @tmp_file = filename
  end

  # source file

  TMP_DIR  = Rails.root / 'tmp'
  TMP_EXT  = '.fallacies.txt'
  TMP_DATE = '%Y%m%d-%H%M%S'
  TMP_GLOB = TMP_DIR / "*#{TMP_EXT}"

  def tmp_info
    return unless (parts = tmp_file&.basename(TMP_EXT).to_s.split '.')&.size == 2
    date_parts = Date._strptime(parts.shift, TMP_DATE).values_at *%i(year mon mday hour min sec)
    [parts.shift, Time.utc(*date_parts)]
  end

  def tmp_file
    @tmp_file ||= Pathname.glob(TMP_GLOB).sort.last
  end

  # seeds file

  YML_FILE = Rails.root / 'db' / 'seeds' / 'fallacies.yml'

  def yml_info
    YAML.load_file(YML_FILE).values_at *%w(sha date) if YML_FILE.file?
  end

  module EncodeTime
    FORMAT = '%Y-%m-%d %H:%M:%S Z'.freeze
    def encode_with coder
      coder.tag = nil
      coder.scalar = getutc.strftime FORMAT
    end
  end

  # parsing

  CRANKY_RECORDS = ['Zero', 'Design Fallacy'].map { |name| "- #{name}" }

  def parse_file
    tmp_file.each_line('', mode: 'rt').with_object([]) do |record, memo|
      memo << parse_record(record) unless record.start_with? *CRANKY_RECORDS
    end if tmp_file&.file?
  end

  CLEANUP_REGEXP = /^(?:#+ (?:Исключено.*$)?)?(?:-+ |")?|"$/ # ..._(?!^)_|"$/ - JS compatible
  EN_LOCALE_REGEXP = /^\.*[a-z]/i
  SENTENCE_END_REGEXP = /[[:punct:]]$/

  LOCALES, ATTRIBUTES = %i(en ru), %i(name description example)
  ATTR_ENUMS = LOCALES.each_with_object({}) { |locale, memo| memo[locale] = ATTRIBUTES.to_enum }

  def parse_record record
    shortened = record.start_with? '#'

    record.gsub! CLEANUP_REGEXP, ''
    record.strip!

    ATTR_ENUMS.each_value(&:rewind)
    prev_locale = attribute = nil

    result = {}

    record.each_line.with_index do |line, index|
      line.squish!

      locale = LOCALES.at line =~ EN_LOCALE_REGEXP || 1
      attribute = ATTR_ENUMS[prev_locale = locale].next if prev_locale != locale || shortened

      if prev_line = (result[locale] ||= {})[attribute]
        dot = '.' unless line.first.downcase == line.first || prev_line =~ SENTENCE_END_REGEXP
        prev_line = "#{prev_line}#{dot} "
      end

      result[locale][attribute] = "#{prev_line}#{line}"
    end

    result
  end
end

namespace 'seeds:fallacies' do

  desc 'Update fallacy seeds file from github source'
  task :update, :offline do |t, args|
    offline = args[:offline] =~ /^(false|f|no|n|0)$/i ? false : !!args[:offline]
    puts FallacySeeds.update offline
  end

  desc 'Update fallacy seeds file from cached source'
  task('update:offline') { Rake::Task['seeds:fallacies:update'].invoke(true) }

  # desc 'Remove cached fallacy seeds source files'
  # task :clean do
  # end

  # desc 'Remove fallacy seeds file and cached source files'
  # task clobber: :clean do
  # end

end
