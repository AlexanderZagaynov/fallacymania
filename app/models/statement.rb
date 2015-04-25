class Statement < ActiveRecord::Base
  include Randomizable

  translates :description
  default_scope { includes(:translations) }
  belongs_to :fallacy, inverse_of: :statements
end
