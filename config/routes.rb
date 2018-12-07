Rails.application.routes.draw do
  resources :meeting_venues
  resources :venues
  resources :user_meetings
  resources :meetings
  resources :users, only:[:show, :edit, :update, :destroy]

  root 'users#new'


  get '/login', to: 'sessions#new', as: 'login'
  post '/sessions', to: 'sessions#create', as: 'sessions'
  post '/logout', to: 'sessions#destroy', as: 'logout'




end
