Rails.application.routes.draw do

  root to: 'home#home'

  post 'home/spotify' => 'home#spotify'

  post 'home/save_data' => 'home#save_data'
  get 'about' => 'home#about'

  get 'newfeatures' => 'home#from_database'
  match 'newfeatures/results' => 'home#show', as: :show, via: [:get, :post]


end
