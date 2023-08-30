Rails.application.routes.draw do
  devise_for :users
  get '/health', to: 'health_checks#index'
  get '/top_page', to: 'top_page#index'
  root to: 'top_page#index'
end
