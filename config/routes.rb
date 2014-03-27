Weafam::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin_gem', :as => 'rails_admin'

  root 'pages#main'

  resources :trees
  resources :profiles
  resources :users
  resources :names
  resources :relations

  match 'main' => 'pages#main', via: :get
  match 'login' => 'pages#login', via: :get
  match 'start' => 'pages#start', via: :get
  match 'admin' => 'pages#admin', via: [:get, :post]
  match 'news' => 'pages#news', via: :get
  match 'mail' => 'pages#mail', via: :get
  match 'settings' => 'pages#settings', via: :get
  match 'mypage' => 'pages#mypage', via: :get
  match 'search' => 'pages#search', via: :get
  match 'conversation' => 'pages#conversation', via: :get
  match 'start_dialoge' => 'pages#start_dialoge', via: :get

  match 'show_start_tree' => 'start#show_start_tree', via: :get
  match 'process_questions' => 'start#process_questions', via: :post

  match 'relative_menu' => 'main#relative_menu', via: :get
  match 'match_approval' => 'main#match_approval', via: :post


  devise_for :users, skip: [:sessions, :registrations]
  devise_scope :user do
    get    "login"   => "devise/sessions#new",         as: :new_user_session
    post   "login"   => "devise/sessions#create",      as: :user_session
    delete "signout" => "devise/sessions#destroy",     as: :destroy_user_session

    get    "signup"  => "devise/registrations#new",    as: :new_user_registration
    post   "signup"  => "devise/registrations#create", as: :user_registration
    put    "signup"  => "devise/registrations#update", as: :update_user_registration
    get    "account" => "devise/registrations#edit",   as: :edit_user_registration
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
