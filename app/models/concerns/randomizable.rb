module Randomizable
  extend ActiveSupport::Concern

  included do
    scope :random, -> { order 'RANDOM()' }
  end
end
