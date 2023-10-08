Rails.application.routes.draw do
  root to: 'top_page#index'
  get '/health', to: 'health_checks#index'
  get '/top_page', to: 'top_page#index'
  get '/db_test', to: 'application#db_test'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  
  resources :users, only: [:show]

end
