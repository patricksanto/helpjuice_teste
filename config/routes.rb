require 'sidekiq/web'

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  get "up" => "rails/health#show", as: :rails_health_check

  get "searches", to: "search#index"
  resources :articles
  root to: "articles#index"

  mount Sidekiq::Web => '/sidekiq'
end
