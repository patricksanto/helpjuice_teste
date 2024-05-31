require 'sidekiq/web'

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  get "up" => "rails/health#show", as: :rails_health_check

  get "search", to: "search#perform_search"
  get "searches", to: "search#index"

  resources :articles, only: [:index]
  root to: "articles#index"

  mount Sidekiq::Web => '/sidekiq'
end
