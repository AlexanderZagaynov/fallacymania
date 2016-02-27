module ApplicationHelper

  def each_locale current_first: false, &block
    locales = current_first ? [I18n.locale] : []
    locales = locales + (I18n.available_locales - locales)
    locales.each { |locale| concat(capture locale, locale == I18n.locale, &block) }
  end

  def navbar_link destination
    name = t destination, scope: :navigation
    options = { class: :current } if controller_path == destination.to_s
    content_tag(:li, options) { link_to name, controller: "/#{destination}" }
  end

end
