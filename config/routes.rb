Rails.application.routes.draw do
 resources :facturas
 
  get 'stocks/show'
 
  get 'stocks/index'
 
   get 'bodegas/initialize'
 
   get 'bodegas/consultarInfo'
 
   get 'bodegas/show'
   
 get '/documentacionAPI', to: 'documentos#index'
  get 'flujos', to: 'documentos#flujos'

  get 'productos', to: 'productos#index'

  get 'almacenes', to: 'almacenes#index'

  get 'layouts/index'

  get 'oc_enviadas', to: 'ocs#oc_enviadas'

  get 'oc_recibidas', to:'ocs#oc_recibidas'

  get 'ocs/:oc/factura', to: 'ocs#factura'

  get 'ocs/show'

  get 'bodegaG7', to: 'stocks#index'

  get 'bodegas/consultar/:id' => 'bodegas#consultarProducto'

  resources :pizzas

  root 'application#index'


  namespace :api, defaults: {format: :json} do
    root  'application#index'
    match '/consultar/:id'=> 'application#consultar', via: :get
    match '/oc/recibir/:id'=> 'application#recibirOc', via: :get
    match '/facturas/recibir/:id'=> 'application#recibirFactura', via: :get
    match '/despachos/recibir/:id'=> 'application#recibirDespacho', via: :get
    match '/pagos/recibir/:idtrx'=> 'application#recibirTrx', via: :get



  end

   namespace :admin do
    root  'application#index'
    match '/bodega/iniciar' => 'application#iniciarBodega', via: :get
    match '/bodega/actualizar' => 'application#actualizarBodega', via: :get
    match '/bodega/vaciarRecepcion' => 'application#vaciarRecepcionBodega', via: :get
    match '/produccion/producirPrimas/:id/:cantidad' => 'application#producirPrimasSkuYCantidad', via: :get
    match '/ftp/consultar' => 'application#consultarFtp', via: :get
    match '/clientes' => 'application#clientes', via: :get
    match '/almacenes' => 'application#almacenes', via: :get
    match '/stocks' => 'application#stocks', via: :get
    match '/ocs' => 'application#ocs', via: :get
    match '/facturas' => 'application#facturas', via: :get
    match '/clientes/iniciar' => 'application#clientesIniciar', via: :get

    

  end

end
