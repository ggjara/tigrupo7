Rails.application.routes.draw do


  get 'bi_financieros' => 'bi_financieros#index'

  get 'bi_financieros/transacciones/:id' => 'bi_financieros#show'

  get 'bi_logistica' => 'bi_logistica#index'


  get 'boletas/:id' => 'bills#show', via: :get

  get 'boletas' => 'bills#index', via: :get


  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/spree'

  match '/spree/confirmarCompra/:id' => 'spree/bills#show', via: :get
   match '/spree/errorCompra/' => 'spree/bills#error', via: :get

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
  resources :facturas

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


   #metodo para hacer pruebas
   get 'queue/send', to: 'queue#put'
   #se debe llamar a recieve para que quede corriendo el thread
   get 'queue/receive', to: 'queue#get'


# Twitter and facebook integration routes :

  # Route to authorize twitter app - only need to do it once (user account = Tigrupo7Com)
  get '/social', to: 'social_networks#index'
  # Route to post on facebook and twitter with the right parameters
  post '/social/publish', to: 'social_networks#publish'


end
