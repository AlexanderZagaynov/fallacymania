class FallaciesController < ApplicationController
  before_action :set_fallacy, only: %i(show edit update destroy)

  def index
    @fallacies = Fallacy.all
  end

  def update
    Globalize.with_locale(@locale) do
      respond_to do |format|
        if @fallacy.update(fallacy_params)
          format.html { redirect_to fallacy_path(@fallacy, locale: @locale), notice: 'Fallacy was successfully updated.' }
          format.json { render :show, status: :ok, location: @fallacy }
        else
          format.html { render :edit }
          format.json { render json: @fallacy.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def set_fallacy
    @fallacy = Fallacy.find(params[:id])
    @locale = params[:locale].try(:to_sym)
  end

  def fallacy_params
    params.require(:fallacy).permit(%i(name description))
  end

end
