Rails.application.routes.draw do

  root to: "users#index"
  resources :users
  devise_for :users

  namespace :api do
    resources :todos, only: %i[create update destroy show index]
  end
end
