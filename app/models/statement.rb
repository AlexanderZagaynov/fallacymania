class Statement < ActiveRecord::Base
  include Randomizable

  translates :description, fallbacks_for_empty_translations: true
  default_scope { includes(:translations) }

  belongs_to :fallacy, inverse_of: :statements

  has_many :results, inverse_of: :statement, dependent: :destroy
end
