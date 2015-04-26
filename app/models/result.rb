class Result < ActiveRecord::Base
  belongs_to :user, inverse_of: :results
  belongs_to :statement, inverse_of: :results
  belongs_to :fallacy, inverse_of: :results # chosen answer
end
