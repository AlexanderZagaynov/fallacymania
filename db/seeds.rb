created = updated = 0
defaults = %i(name description example).each_with_object({}) { |key, hash| hash[key] = '' }

file = Rails.root / 'db' / 'seeds' / 'fallacies.yml'
YAML.load_stream(file.read, file).from(1).each do |item|
  item = item.with_indifferent_access

  fallacy = Fallacy.find_or_initialize_by slug: item[:en][:name].parameterize
  fallacy.new_record? ? created += 1 : updated += 1

  item.each do |locale, attributes|
    Globalize.with_locale(locale) { fallacy.attributes = attributes.reverse_merge defaults }
  end

  fallacy.save!
end

['Created', created, 'Updated', updated].each_slice(2) do |name, count|
  puts "#{name} #{count} #{'record'.pluralize(count)}."
end
