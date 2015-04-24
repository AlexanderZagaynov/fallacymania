DATA_URL = 'https://raw.githubusercontent.com/ub/rhetological-fallacies-Russian/master/text/translation.txt'
NAME_EN_RX = /\A- /
NAME_RU_RX = /\A-- /
COMMENT_RX = /\A#/
QUOTES_RX = /\A"|"\z/

I18n.locale = :en

class FallacyComposer
  cattr_accessor *%i(name_en description_en statement_en name_ru description_ru statement_ru)
  cattr_accessor *%i(count_new count_old count_nil)

  self.count_new = self.count_old = 0
  @state = 0 # 1 == name_en, 2 == name_ru, 3 == desc_en, 4 == desc_ru, 5 == stat_en, 6 == stat_ru

  def self.add_data(data_line)
    data_line.squish!

    case

    when data_line.blank? || data_line =~ COMMENT_RX

      # skip

    when data_line =~ NAME_EN_RX

      save_data
      self.name_en = data_line.sub(NAME_EN_RX, '')
      @state = 1

    when @state == 1 && data_line =~ NAME_RU_RX

      self.name_ru = data_line.sub(NAME_RU_RX, '')
      @state = 2

    when @state == 2

      self.description_en = data_line
      @state = 3

    when @state == 3

      self.description_ru = data_line
      @state = 4

    when @state == 4

      self.statement_en = data_line.gsub(QUOTES_RX, '')
      @state = 5

    when @state == 5

      self.statement_ru = data_line.gsub(QUOTES_RX, '')
      @state = 6

    else

      @state = 0 # assure good condition of the record block

    end
  end

  def self.save_data
    if @state == 6

      fallacy = Fallacy.find_or_initialize_by(slug: name_en.parameterize)
      statement = fallacy.statements.first_or_initialize

      fallacy.new_record? ? self.count_new += 1 : self.count_old += 1

      Globalize.with_locale(:en) do
        fallacy.name = name_en
        fallacy.description = description_en
        statement.description = statement_en
      end

      Globalize.with_locale(:ru) do
        fallacy.name = name_ru
        fallacy.description = description_ru
        statement.description = statement_ru
      end

      fallacy.save!
      statement.save!

    elsif self.count_nil.nil?
      self.count_nil = 0
    else
      self.count_nil += 1
      puts "Missed record: #{name_en} / #{description_en} / #{name_ru} / #{description_ru}"
    end
  end

  def self.info(count_attr)
    count = send(count_attr)
    "#{count} #{'record'.pluralize(count)}"
  end
end

puts 'Downloading file...'
data_file = Net::HTTP.get(URI DATA_URL)
# data_file = IO.read("#{Rails.root}/tmp/translation.txt")

puts 'File downloaded, processing...'
data_file.each_line { |data_line| FallacyComposer.add_data(data_line) }
FallacyComposer.save_data

puts "Created #{FallacyComposer.info(:count_new)}"
puts "Updated #{FallacyComposer.info(:count_old)}"
puts "Missed #{FallacyComposer.info(:count_nil)}"

puts 'Done!'
