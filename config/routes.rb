Rails.application.routes.draw do

  match '/api/documentacion'=> 'documentos#metodos', via: :get
  get 'flujos', to: 'documentos#flujos'

  get 'productos', to: 'productos#show'

  get 'almacenes', to: 'almacenes#show'

  get 'layouts/index'

  get 'oc_enviadas', to: 'ocs#oc_enviadas'

  get 'oc_recibidas', to:'ocs#oc_recibidas'

  get 'ocs/:oc/factura', to: 'ocs#factura'

  get 'ocs/show'

  get 'bodegaG7', to: 'bodegas#show'

  get 'bodegas/consultar/:id' => 'bodegas#consultarProducto'

  resources :pizzas

  root 'almacenes#show'
  match '/iniciar' => 'bodegas#iniciarBodega', via: :get
  match '/consultar' => 'bodegas#consultarInfo', via: :get
  match '/consultarFtp' => 'application#consultarFtp', via: :get


  namespace :api, defaults: {format: :json} do
    root  'application#index'
    match '/consultar/:id'=> 'application#consultar', via: :get
    match '/oc/recibir/:id'=> 'application#recibirOc', via: :get
    match '/facturas/recibir/:id'=> 'application#recibirFactura', via: :get
    match '/despachos/recibir/:id'=> 'application#recibirDespacho', via: :get
    match '/pagos/recibir/:id'=> 'application#recibirTrx', via: :get

  end

end
