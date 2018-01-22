Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/history', to: 'games#history'
  get '/log',     to: 'games#new'
  
  resources :games
end
