Rails.application.routes.draw do
  devise_for :users
  root to: "games#leaderboard"
  get '/history', to: 'games#history'
  get '/log',     to: 'games#new'
  get '/leaderboard', to: 'games#leaderboard'
  
  resources :games
end
