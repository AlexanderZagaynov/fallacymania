class FallaciesController < ApplicationController
  # before_action :set_fallacy, only: %i(show edit update destroy)

  def index
    @fallacies = Fallacy.all
  end

  # private

  # def set_fallacy
  #   @fallacy = Fallacy.find(params[:id])
  # end

  # def fallacy_params
  #   params.require(:fallacy).permit(:slug)
  # end
end
