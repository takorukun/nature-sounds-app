Rails.application.routes.draw do
  root to: 'top_page#index'
  get '/health', to: 'health_checks#index'
  get '/top_page', to: 'top_page#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, only: [:show]

end
