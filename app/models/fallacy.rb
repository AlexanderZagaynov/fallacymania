class Fallacy < ActiveRecord::Base
  extend FriendlyId
  include Randomizable

  friendly_id :slug

  translates :name, :description, fallbacks_for_empty_translations: true
  default_scope { includes(:translations) }

  has_many :statements, inverse_of: :fallacy, dependent: :restrict_with_error

  belongs_to :statement # primary sample
  delegate :description, to: :statement, prefix: true, allow_nil: true

  has_many :results, inverse_of: :fallacy, dependent: :destroy

  # def cache_key
  #   "#{super}-#{Globalize.locale}"
  # end
end
