class Sophism < ActiveRecord::Base
  translates :description
  belongs_to :fallacy, inverse_of: :sophisms
end
