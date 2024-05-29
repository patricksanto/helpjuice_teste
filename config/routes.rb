Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "articles#index"
  resources :articles
end
