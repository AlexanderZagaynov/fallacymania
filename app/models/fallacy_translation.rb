class FallacyTranslation < ActiveRecord::Base
  belongs_to :fallacy, inverse_of: :translations
  belongs_to :sample, class_name: 'FallacySample'
end
