Rails.application.routes.draw do

  resources :statements, only: :index

  controller :game, as: :game, path: :game, format: false do
    get :show, path: '', format: nil
    post :start
    put 'difficulty/:level', action: :difficulty, as: :difficulty
    post 'commit/:fallacy', action: :commit, as: :commit
  end

  get :results, controller: :results, action: :index

  resources :fallacies, only: :index do
    member do
      get '/:locale', action: :show, as: ''
      get '/:locale/edit', action: :edit, as: :edit
      patch '/:locale', action: :update
    end
  end

  controller :settings, as: :set, path: :set, format: false do
    put 'locale/:locale', action: :locale, as: :locale
  end

  root controller: :pages, action: :index
end
