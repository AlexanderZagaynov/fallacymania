Rails.application.routes.draw do
  resource(:profile, controller: :users, only: %i[show update]) { post :update }
  resources :fallacies, only: :index
end
