Weafam::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin_gem', :as => 'rails_admin'

  root 'pages#landing'

  resources :trees
  resources :profiles
  resources :users
  resources :names
  resources :relations

  # pages controller
  match 'main' => 'pages#main', via: :get
  match 'landing' => 'pages#landing', via: :get
  match 'admin' => 'pages#admin', via: :get
  match 'news' => 'pages#news', via: :get
  match 'mail' => 'pages#mail', via: :get
  match 'mypage' => 'pages#mypage', via: :get
  match 'search' => 'pages#search', via: :get
  match 'conversation' => 'pages#conversation', via: :get
  match 'start_enter' => 'pages#start_enter', via: :get
  match 'start_dialoge' => 'pages#start_dialoge', via: :get # запуск процесса диалогового ввода стартового древа

  #todo: убрать путаницу в названиях методов main и start
  # main controller
  match 'main_page' => 'main#main_page', via: :get
  match 'relative_menu' => 'main#relative_menu', via: :get
  match 'match_approval' => 'main#match_approval', via: :get

  # start controller
  match 'show_tree_table' => 'start#show_tree_table', via: :get
  match 'display_saved_tree' => 'start#display_saved_tree', via: :get


  ######### start_enter/enters
  get 'enter_myself' => "start/enter_myself", via: :get
  get 'enter_father' => "start/enter_father", via: :get
  get 'enter_mother' => "start/enter_mother", via: :get
  get 'enter_brother' => "start/enter_brother", via: :get
  get 'enter_sister' => "start/enter_sister", via: :get
  get 'enter_son' => "start/enter_son", via: :get
  get 'enter_daugther' => "start/enter_daugther", via: :get
  get 'enter_husband' => "start/enter_husband", via: :get
  get 'enter_wife' => "start/enter_wife", via: :get
  get 'enter_final' => "start/enter_final", via: :get


  ######### start/checks

  get 'check_brothers' => "start/check_brothers", via: :post
  get 'check_sisters' => "start/check_sisters", via: :post
  get 'check_sons' => "start/check_sons", via: :post
  get 'check_daugthers' => "start/check_daugthers", via: :post
  get 'check_husband' => "start/check_husband", via: :post
  get 'check_wife' => "start/check_wife", via: :post


  ######### start/__store
  get 'store_myself' => "start/store_myself", via: :post
  get 'store_father' => "start/store_father", via: :post
  get 'store_mother' => "start/store_mother", via: :post
  get 'store_brother' => "start/store_brother", via: :post
  get 'store_sister' => "start/store_sister", via: :post
  get 'store_son' => "start/store_son", via: :post
  get 'store_daugther' => "start/store_daugther", via: :post
  get 'store_husband' => "start/store_husband", via: :post
  get 'store_wife' => "start/store_wife", via: :post



  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions"}, skip: [:sessions, :registrations]
  devise_scope :user do
    get    "login"   => "users/sessions#new",         as: :new_user_session
    post   "login"   => "users/sessions#create",      as: :user_session
    delete "signout" => "users/sessions#destroy",     as: :destroy_user_session

    get    "signup"  => "users/registrations#new",    as: :new_user_registration
    post   "signup"  => "users/registrations#create", as: :user_registration
    put    "signup"  => "users/registrations#update", as: :update_user_registration
    get    "account" => "users/registrations#edit",   as: :edit_user_registration
  end

#  post "admin/login"

# You can have the root of your site routed with "root"
# root 'welcome#index'

#  match 'admin' => 'admin#index', via: :get







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
