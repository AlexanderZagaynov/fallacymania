class FallaciesController < ApplicationController

  def index
    @fallacies = Fallacy.includes(:translations).all
  end

end
