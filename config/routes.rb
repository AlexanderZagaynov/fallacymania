Rails.application.routes.draw do

  resources :fallacies, only: :index

  root controller: :pages, action: :index
end
