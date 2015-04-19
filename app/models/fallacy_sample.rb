class FallacySample < ActiveRecord::Base
  belongs_to :fallacy, inverse_of: :samples
end
