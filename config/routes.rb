Rails.application.routes.draw do

  root to: "users#index"
  resources :users
  resources :products, only: %i[index show]
  devise_for :users

  namespace :api do
    resources :todos, only: %i[create update destroy show index]
    resources :products, only: %i[create update destroy show index]
  end
end
