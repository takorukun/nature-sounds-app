Rails.application.routes.draw do
  root 'application#index'
  get '/health', to: 'application#health'
end
