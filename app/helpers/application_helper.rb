module ApplicationHelper

  def navbar_link destination
    name = t destination, scope: :navigation
    options = { class: :active } if controller_path == destination.to_s
    content_tag(:li, options) { link_to name, controller: "/#{destination}" }
  end

end
