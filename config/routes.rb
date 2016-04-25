Rails.application.routes.draw do
  resources :pizzas

  root 'application#index'

  namespace :api, defaults: {format: :json} do
    root  'application#index'
    match '/prueba'=> 'application#prueba', via: :get
    match '/consultar/:id'=> 'application#consultar', via: :get

  end

end
