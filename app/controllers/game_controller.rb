class GameController < ApplicationController
  HARD_LEVEL_SIZE, NORMAL_LEVEL_SIZE, EASY_LEVEL_SIZE = 20, 10, 3

  def show
    @statement = Statement.find(session[:statement])
    if session[:fallacy]
      @fallacy = Fallacy.find(session[:fallacy])
      render :score
    else
      @fallacies = Fallacy.find(session[:fallacies]).shuffle!
      @levels = { hard: HARD_LEVEL_SIZE, normal: NORMAL_LEVEL_SIZE, easy: EASY_LEVEL_SIZE }
    end
  end

  def start
    difficulty = HARD_LEVEL_SIZE
    statement_id = Statement.random_id
    fallacy_ids = Fallacy.random_ids(difficulty, fallacy_id_for_statement_id(statement_id))

    session[:difficulty] = difficulty
    session[:statement] = statement_id
    session[:fallacies] = fallacy_ids
    session[:fallacy] = nil

    redirect_to action: :show
  end

  def difficulty
    old_level, new_level = session[:difficulty].try(:to_i), params[:level].try(:to_i)

    if new_level && (!old_level || new_level < old_level)
      session[:difficulty] = new_level

      fallacy_id = fallacy_id_for_statement_id(session[:statement])
      fallacy_ids = Array(session[:fallacies])
      fallacy_ids.delete(fallacy_id)
      fallacy_ids = fallacy_ids.sample(new_level - 1) + Array(fallacy_id)

      session[:fallacies] = fallacy_ids
    end

    redirect_to action: :show
  end

  def commit
    # #session[:result] =
    # current_user.results.create! do |result|
    #   result.statement = Statement.includes(:fallacy).find(session[:statement])
    #   result.fallacy = Fallacy.find(session[:fallacy])
    #   result.correct = (result.statement.fallacy == result.fallacy)
    #   result.locale = session[:locale]
    #   result.difficulty = session[:difficulty]
    # end
    session[:fallacy] = params[:fallacy] unless session[:fallacy]
    redirect_to action: :show
  end

  private

  def fallacy_id_for_statement_id(statement_id)
    Statement.unscoped.where(id: statement_id).pluck(:fallacy_id).first
  end
end
