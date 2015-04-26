class User < ActiveRecord::Base
  has_many :results, inverse_of: :user, dependent: :destroy
end
