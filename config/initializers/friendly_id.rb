FriendlyId.defaults do |config|

  config.base :slug
  config.use :finders

  config.use :reserved
  config.reserved_words =
    %w(new edit index session login logout users admin stylesheets assets javascripts images)

end
