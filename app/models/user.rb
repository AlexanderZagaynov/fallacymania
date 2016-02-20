class User < ActiveRecord::Base
  has_many :sessions, inverse_of: :user, dependent: :destroy
  validates_inclusion_of :locale, in: I18n.available_locales.map(&:to_s)
end
