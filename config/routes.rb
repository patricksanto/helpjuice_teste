Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "search", to: "search#index"
  resources :articles
  root to: "articles#index"
end
