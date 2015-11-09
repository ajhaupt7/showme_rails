Rails.application.routes.draw do

  root to: 'home#home'

  post 'home/spotify' => 'home#spotify'
  get 'about' => 'home#about'

  get 'newfeatures' => 'home#from_database'
  get 'newfeatures/results' => 'home#show'


end
