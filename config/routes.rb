# encoding: utf-8


Weafam::Application.routes.draw do

#  post "admin/login"

# You can have the root of your site routed with "root"
# root 'welcome#index'
  root 'pages#login'

#  match 'admin' => 'admin#index', via: :get
  match 'main' => 'pages#main', via: :get
  match 'login' => 'pages#login', via: :get
  match 'start' => 'pages#start', via: :get
  match 'admin' => 'pages#admin', via: :get
  match 'news' => 'pages#news', via: :get
  match 'mail' => 'pages#mail', via: :get
  match 'settings' => 'pages#settings', via: :get
  match 'registration' => 'pages#registration', via: :get
  match 'settings' => 'pages#settings', via: :get
  match 'mypage' => 'pages#mypage', via: :get
  match 'search' => 'pages#search', via: :get
  match 'conversation' => 'pages#conversation', via: :get


  resources :names
  resources :relations


  get "pages/admin"
  post "pages/admin"

  get "pages/start"
  post "pages/start"

  get "pages/login"
  post "pages/login"

  get "pages/registration"
  post "pages/registration"

  get "pages/main"
  post "pages/main"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".




  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end





end
