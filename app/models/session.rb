class Session < ActiveRecord::SessionStore::Session # ActiveRecord::Base
  belongs_to :user, inverse_of: :sessions
  before_validation :set_user, on: :create

  private

  def set_user
    self.user = User.create!(guest: true) unless user.present? # TODO: data[:user] ???
  end
end
