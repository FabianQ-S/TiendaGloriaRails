Rails.application.routes.draw do
  # Rutas de autenticación
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout
  
  get "registrarse", to: "registrations#new", as: :register
  post "registrarse", to: "registrations#create"

  # Tienda pública
  root "store#index"
  get "tienda", to: "store#index", as: :store
  get "producto/:id", to: "store#show", as: :store_product

  # Carrito
  get "carrito", to: "carts#show", as: :cart
  post "carrito/agregar/:id", to: "carts#add", as: :add_to_cart
  delete "carrito/quitar/:id", to: "carts#remove", as: :remove_from_cart
  patch "carrito/cantidad/:id", to: "carts#update_quantity", as: :update_cart_quantity
  post "carrito/comprar", to: "carts#checkout", as: :checkout

  # Perfil de usuario
  get "perfil", to: "profile#edit", as: :profile
  patch "perfil", to: "profile#update"

  # Direcciones del usuario
  resources :addresses, except: [:show]

  # Namespace Admin
  namespace :admin do
    root "dashboard#index"
    get "dashboard", to: "dashboard#index", as: :dashboard
    resources :products
    resources :categories
    resources :providers
    resources :batches
    resources :users, only: [:index, :show]
    resources :orders, only: [:index, :show, :update]
    resources :roles
  end

  # Recursos scaffold originales (para mantener compatibilidad)
  resources :order_items
  resources :orders
  resources :batches
  resources :products
  resources :categories
  resources :providers
  resources :addresses
  resources :users
  resources :roles

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
