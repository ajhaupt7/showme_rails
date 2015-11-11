Rails.application.routes.draw do

  root to: 'home#home'

  match 'home/spotify' => 'home#spotify', as: :user_account, via: [:get, :post]

  post 'home/save_data' => 'home#save_data'
  get 'about' => 'home#about'

  get 'newfeatures' => 'home#from_database'
  get 'newfeatures/results' => 'home#show'


end
