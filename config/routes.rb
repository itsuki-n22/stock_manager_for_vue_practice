Rails.application.routes.draw do

  root to: "products#index"
  resources :users
  resources :products, only: %i[index show create]
  devise_for :users

  namespace :api do
    resources :todos, only: %i[create update destroy show index]
    resources :products, only: %i[create update destroy show index] 
    resources :stocks, only: %i[update] 
    resources :alias_ids, only: %i[update] 
  end
end
