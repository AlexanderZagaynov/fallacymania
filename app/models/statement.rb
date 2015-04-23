class Statement < ActiveRecord::Base
  translates :description
  default_scope { includes(:translations) }
  belongs_to :fallacy, inverse_of: :statements
end
