module I18n
  def self.another_locales
    available_locales - Array(locale)
  end
end
