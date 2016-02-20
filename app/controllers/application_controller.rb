class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_globals

  private

  def set_globals
    token = session[:token] ||= SecureRandom.hex
    @session = Session.find_or_create_by token: token do |session|
      locale ||= http_accept_language.compatible_language_from I18n.available_locales
      locale ||= I18n.default_locale
      session.build_user guest: true, locale: locale
    end
    @user = @session.user
    I18n.locale = @user.locale
  end
end
