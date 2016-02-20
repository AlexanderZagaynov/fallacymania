class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # private
  #
  # def set_locale
  #   session[:locale] = I18n.locale =
  #     (Array(session[:locale].try(:to_sym)) & I18n.available_locales).first ||
  #       http_accept_language.compatible_language_from(I18n.available_locales)
  # end
  #
  # def current_user
  #   if session[:user]
  #     user = User.find(session[:user])
  #   else
  #     user = User.create!(guest: true)
  #     session[:user] = user.id
  #   end
  #   user
  # end
end
