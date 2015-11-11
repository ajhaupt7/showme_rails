Rails.application.routes.draw do

  root to: 'home#home'

  get 'about' => 'home#about'

  match 'results' => 'home#results', via: [:get, :post]


end
