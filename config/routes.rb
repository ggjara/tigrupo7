Rails.application.routes.draw do
  get 'metodos', to: 'documentos#metodos'

  get 'flujos', to: 'documentos#flujos'

  get 'productos', to: 'productos#show'

  get 'almacenes', to: 'almacenes#show'

  get 'layouts/index'

  get 'oc_enviadas', to: 'ocs#oc_enviadas'

  get 'oc_recibidas', to:'ocs#oc_recibidas'

  get 'ocs/pagosAsociados'

  get 'ocs/show'

  get 'bodegaG7', to: 'bodegas#show'

  get 'bodegas/consultar/:id' => 'bodegas#consultarProducto'

  resources :pizzas

  root 'application#index'
  match '/iniciar' => 'bodegas#iniciarBodega', via: :get
  match '/consultar' => 'bodegas#consultarInfo', via: :get
  match '/consultarFtp' => 'application#consultarFtp', via: :get


  namespace :api, defaults: {format: :json} do
    root  'application#index'
    match '/consultar/:id'=> 'application#consultar', via: :get
    match '/oc/recibir/:id'=> 'application#recibirOc', via: :post
    match '/facturas/recibir/:id'=> 'application#recibirFactura', via: :post
    match '/pagos/recibir/:id'=> 'application#recibirTrx', via: :post

  end

end
