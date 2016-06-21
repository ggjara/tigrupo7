Rails.application.routes.draw do

  get 'twitter/createTwitterSession'

  get 'twitter/destroyTwitterSession'

  get 'twitter/createTweet'

  get 'twitter/newTweet'

  get 'twitter/twitter_params'

  get 'twitter/current_twitter_user'

  get 'facebook/initialize'

  get 'facebook/page_wall_post'

  get 'social_networks/new'

  get 'social_networks/index'

  get 'social_networks/newTwitterSession'

  get 'social_networks/createTwitterSession'

  get 'social_networks/destroyTwitterSession'

  get 'social_networks/newTweet'

  get 'social_networks/createTweet'

  get 'home/show'

  get 'tweets/new'

  get 'tweets/create'

  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  get 'home/show'

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




# Twitter integration routes
    
  get '/auth/:provider/callback', to: 'twitter#createTwitterSession'
  get '/auth/failure', to: redirect('/')
  get '/signout', to: 'twitter#destroyTwitterSession', as: 'signout'

    get '/twitter', to: 'twitter#index'

    
  post  '/twitter/createTweet(.:format)', to: 'twitter#createTweet'
   

   resource :twitter, only: [:newTweet, :createTweet, :createTwitterSession, :destroyTwitterSession]
# Facebook integration routes

# match '/facebook' => 'social_networks#indexFacebook', via: :get
# match '/social_networks/login' => 'social_networks#signinfacebook', via: :get
# match '/login' => 'social_networks#signinfacebook', via: :get
# match '/facebookMethod' => 'social_networks#facebookMethod', via: :post

# match 'callback_url' => 'social_networks#facebookMethod', via: :post
#Facebook Posters
  get '/social', to: 'social_networks#index'
  post 'facebook/article', to: 'facebook#page_wall_post'

  


    

  

end
