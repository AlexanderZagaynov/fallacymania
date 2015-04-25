class Fallacy < ActiveRecord::Base
  include Randomizable

  extend FriendlyId; friendly_id :slug
  translates :name, :description, fallbacks_for_empty_translations: true
  default_scope { includes(:translations) }

  has_many :statements, inverse_of: :fallacy
  belongs_to :statement
  delegate :description, to: :statement, prefix: true, allow_nil: true

  def cache_key
    "#{super}-#{Globalize.locale}"
  end
end
