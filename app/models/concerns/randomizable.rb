module Randomizable
  extend ActiveSupport::Concern

  included do
    scope :random, -> { order 'RANDOM()' }
  end

  class_methods do

    def random_ids count = 1, with_id = nil
      scope = unscoped.random
      result = Array(with_id)
      if with_id
        count -= 1
        scope = scope.where.not(id: with_id)
      end
      result += scope.limit(count).ids unless count.zero?
      result
    end

    def random_id
      random_ids.first
    end

  end
end
