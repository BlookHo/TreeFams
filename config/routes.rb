# encoding: utf-8


Weafam::Application.routes.draw do

  resources :trees
  resources :profiles
  resources :users
  resources :names
  resources :relations

#  post "admin/login"

# You can have the root of your site routed with "root"
# root 'welcome#index'
  root 'pages#login'

#  match 'admin' => 'admin#index', via: :get


  match 'main' => 'pages#main', via: :get
  match 'login' => 'pages#login', via: :get
#  match 'start_enter' => 'pages#start_enter', via: :get; :post # уточнить синтаксис чтобы и post
  match 'admin' => 'pages#admin', via: :get
  match 'news' => 'pages#news', via: :get
  match 'mail' => 'pages#mail', via: :get
  match 'settings' => 'pages#settings', via: :get
  match 'registration' => 'pages#registration', via: :get
  match 'settings' => 'pages#settings', via: :get
  match 'mypage' => 'pages#mypage', via: :get
  match 'search' => 'pages#search', via: :get
  match 'conversation' => 'pages#conversation', via: :get

  match 'show_tree_table' => 'start#show_tree_table', via: :get


  get "pages/admin"
  post "pages/admin"

  get "pages/start_enter"
  post "pages/start_enter"

  get "pages/start_dialoge"
  post "pages/start_dialoge"

  get "pages/login"
  post "pages/login"

  get "pages/registration"
  post "pages/registration"

  get "pages/main"
  post "pages/main"

  ######### start_enter/enters

  get "start/enter_myself"
  get "start/enter_father"
  get "start/enter_mother"
  get "start/enter_brother"
  get "start/enter_sister"
  get "start/enter_son"
  get "start/enter_daugther"
  get "start/enter_husband"
  get "start/enter_wife"
  get "start/enter_final"

  ######### start/checks

  get "start/check_brothers"
  post "start/check_brothers"

  get "start/check_sisters"
  post "start/check_sisters"

  get "start/check_sons"
  post "start/check_sons"

  get "start/check_daugthers"
  post "start/check_daugthers"

  get "start/check_husband"
  post "start/check_husband"

  get "start/check_wife"
  post "start/check_wife"

  ######### start/__store

  post "start/store_myself"
  post "start/store_father"
  post "start/store_mother"
  post "start/store_brother"
  post "start/store_sister"
  post "start/store_son"
  post "start/store_daugther"
  post "start/store_husband"
  post "start/store_wife"

  ##########
  #########


  get "main/relative_menu"
  post "main/relative_menu"

  get "main/match_approval"
  post "main/match_approval"




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
