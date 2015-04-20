class Fallacy < ActiveRecord::Base
  translates :name, :description
  has_many :sophisms, inverse_of: :fallacy
end
