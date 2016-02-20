Rails.application.routes.draw do
  root controller: :pages, action: :index
  resource(:profile, controller: :users, only: %i[show update]) { post :update }

  resources :fallacies, only: :index
end
