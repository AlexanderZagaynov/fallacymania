class Fallacy < ActiveRecord::Base
  with_options inverse_of: :fallacy do
    has_many :translations, class_name: 'FallacyTranslation'
    has_many :samples, class_name: 'FallacySample'
  end
end
