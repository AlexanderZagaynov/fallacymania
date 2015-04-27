class ResultsController < ApplicationController
  def index
    @results = current_user.results.includes(:fallacy, statement: :fallacy)
  end
end
