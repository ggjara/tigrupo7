Rails.application.routes.draw do
  resources :pizzas

  root 'pizzas#index'

  namespace :api, defaults: {format: :json} do

  end

end
