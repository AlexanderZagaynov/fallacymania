module I18n
  def self.another_locales(without_locale = nil)
    available_locales - Array(without_locale || locale)
  end
end
