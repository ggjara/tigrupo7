Rails.application.routes.draw do
  get 'layouts/index'

  get 'ocs/despachos'

  get 'ocs/facturas'

  get 'ocs/pagosAsociados'

  get 'ocs/show'

  get 'bodegaG7', to: 'bodegas#show'
  get 'bodegas/consultar/:id' => 'bodegas#consultarProducto'

  resources :pizzas

  root 'application#index'
  match '/iniciar' => 'bodegas#crearInfo', via: :get
  match '/consultar' => 'bodegas#consultarInfo', via: :get
  match '/consultarFtp' => 'application#consultarFtp', via: :get
  namespace :api, defaults: {format: :json} do
    root  'application#index'
    match '/consultar/:id'=> 'application#consultar', via: :get

  end

end
