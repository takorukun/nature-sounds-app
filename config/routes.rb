Rails.application.routes.draw do
  root to: 'top_page#index'
  get '/health', to: 'health_checks#index'
  get '/top_page', to: 'top_page#index'

  resources :videos do
    collection do
      get 'profile'
    end
  end

  resources :meditations do
    collection do
      get 'meditate'
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  
  resources :users, only: [:show]
  resources :videos
  resources :meditations, only: [:new, :edit]
end
