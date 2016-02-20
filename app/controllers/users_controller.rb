class UsersController < ApplicationController

  def update
    @user.update params.permit %i(locale)
    redirect_to request.referer || root_path
  end

end
