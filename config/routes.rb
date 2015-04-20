Rails.application.routes.draw do

  resources :fallacies, only: :index

  controller :settings, as: :set, path: :set, format: false do
    put 'locale/:locale', action: :locale, as: :locale
  end

  root controller: :pages, action: :index
end
