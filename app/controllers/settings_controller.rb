class SettingsController < ApplicationController
  def locale
    session[:locale] = params[:locale]
    redirect_to request.referer || root_path
  end
end
