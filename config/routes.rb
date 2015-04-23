Rails.application.routes.draw do

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
