# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'rails/health#show'

  resource :cart, only: %i[show create] do
    post :add_item
    delete ':product_id', to: 'carts#remove_item'
  end
end
