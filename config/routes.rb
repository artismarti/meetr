Rails.application.routes.draw do
  resources :user_meetings
  resources :meetings
  resources :users

  get '/login', to: 'sessions#new', as: 'login'
  post '/sessions', to: 'sessions#create', as: 'sessions'
  post '/logout', to: 'sessions#destroy', as: 'logout'

end
