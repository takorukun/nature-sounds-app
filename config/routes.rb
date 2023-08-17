Rails.application.routes.draw do
  get '/health', to: 'health_checks#index'
  root 'application#index'
end
