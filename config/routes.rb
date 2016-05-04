Rails.application.routes.draw do

  match '/api/documentacion'=> 'documentos#metodos', via: :get
  get 'flujos', to: 'documentos#flujos'

  get 'productos', to: 'productos#index'

  get 'almacenes', to: 'almacenes#index'

  get 'layouts/index'

  get 'oc_enviadas', to: 'ocs#oc_enviadas'

  get 'oc_recibidas', to:'ocs#oc_recibidas'

  get 'ocs/:oc/factura', to: 'ocs#factura'

  get 'ocs/show'

  get 'bodegaG7', to: 'bodegas#show'

  get 'bodegas/consultar/:id' => 'bodegas#consultarProducto'

  root 'almacenes#index'
  
  


  namespace :api, defaults: {format: :json} do
    root  'application#index'
    match '/consultar/:id'=> 'application#consultar', via: :get
    match '/oc/recibir/:id'=> 'application#recibirOc', via: :get
    match '/facturas/recibir/:id'=> 'application#recibirFactura', via: :get
    match '/despachos/recibir/:id'=> 'application#recibirDespacho', via: :get
    match '/pagos/recibir/:id'=> 'application#recibirTrx', via: :get

  end

   namespace :admin do
    root  'application#index'
    match '/iniciarBodega' => 'application#iniciarBodega', via: :get
    match '/actualizarBodega' => 'application#actualizarBodega', via: :get
    match '/consultarFtp' => 'application#consultarFtp', via: :get
    match '/producirPrimas/:id/:cantidad' => 'application#producirPrimasSkuYCantidad', via: :get
    match '/producirPrimas/:id' => 'application#producirPrimasSku', via: :get
    match '/prueba' => 'application#prueba', via: :get

  end

end
