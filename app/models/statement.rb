class Statement < ActiveRecord::Base
  translates :description
  belongs_to :fallacy, inverse_of: :statements
end
