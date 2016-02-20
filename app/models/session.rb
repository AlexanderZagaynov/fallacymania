class Session < ActiveRecord::Base
  belongs_to :user, inverse_of: :sessions, counter_cache: true, touch: true
end
