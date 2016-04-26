Rails.application.routes.draw do
  resources :pizzas

  root 'application#index'
  match '/iniciar' => 'bodegas#crearInfo', via: :get
  match '/consultar' => 'bodegas#consultarInfo', via: :get
  namespace :api, defaults: {format: :json} do
    root  'application#index'
    match '/consultar/:id'=> 'application#consultar', via: :get

  end

end
