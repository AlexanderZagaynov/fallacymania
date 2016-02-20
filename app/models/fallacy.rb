class Fallacy < ActiveRecord::Base
  extend FriendlyId
  include Randomizable

  translates :name, :description, :example, fallbacks_for_empty_translations: true
end
