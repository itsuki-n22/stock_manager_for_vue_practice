Rails.application.routes.draw do

  root to: "products#index"
  resources :users
  resources :products, only: %i[index show create]
  resources :orders, only: %i[index]
  devise_for :users

  namespace :api do
    resources :todos, only: %i[create update destroy show index]
    resources :products, only: %i[create update destroy show index] do
      post :import, on: :collection
    end
    resources :orders, only: %i[create update destroy show index] do
      post :import, on: :collection
    end
    resources :stocks, only: %i[update] 
    resources :product_memos, only: %i[create update] 
    resources :order_memos, only: %i[create update] 
    resources :shipping_items, only: %i[destroy] 
    resources :alias_ids, only: %i[update] 
  end
end
