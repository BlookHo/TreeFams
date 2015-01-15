Weafam::Application.routes.draw do


  resources :updates_events

  resources :updates_feeds, except: [:update, :show, :destroy, :new, :edit]

  resources :weafam_settings

  resources :connection_requests
  # connection_requests_controller
  match 'show_user_requests' => 'connection_requests#show_user_requests', via: :get
  match 'show_user_requests' => 'connection_requests#show_user_requests', via: :post

  match 'show_one_request' => 'connection_requests#show_one_request', via: :get
  match 'show_one_request' => 'connection_requests#show_one_request', via: :post

  match 'yes_connect' => 'connection_requests#yes_connect', via: :get
  match 'yes_connect' => 'connection_requests#yes_connect', via: :post

  match 'no_connect' => 'connection_requests#no_connect', via: :get
  match 'no_connect' => 'connection_requests#no_connect', via: :post

  match 'make_connection_request' => 'connection_requests#make_connection_request', via: :get
  match 'make_connection_request' => 'connection_requests#make_connection_request', via: :post



  # search similars & connecting
  # SearchSimilars controller
  match 'internal_similars_search' => 'search_similars#internal_similars_search', via: :get
  get 'search_similars/index'
  match 'connect_similars' => 'search_similars#connect_similars', via: :get
  match 'keep_disconnected_similars' => 'search_similars#keep_disconnected_similars', via: :get
  match 'connect_similars' => 'search_similars#connect_similars', via: :post
  match 'keep_disconnected_similars' => 'search_similars#keep_disconnected_similars', via: :post

  # messages controller
  resources :messages, except: [:update, :show, :destroy, :edit]


  match 'send_message' => 'messages#send_message', via: :get
  match 'send_message' => 'messages#send_message', via: :post

  match 'enter_new_message' => 'messages#enter_new_message', via: :get
  match 'enter_new_message' => 'messages#enter_new_message', via: :post

  match 'write_new_message' => 'messages#new_message', via: :get, as: :write_new_message
  match 'write_new_message' => 'messages#new_message', via: :post, as: :send_new_message

  match 'show_all_messages' => 'messages#show_all_messages', via: :get
  match 'show_all_messages' => 'messages#show_all_messages', via: :post

  match 'show_all_dialoges' => 'messages#show_all_dialoges', via: :get
  #match 'show_all_dialoges' => 'messages#show_all_dialoges', via: :post

  match 'show_one_dialoge' => 'messages#show_one_dialoge', via: :get
  #match 'show_one_dialoge' => 'messages#show_one_dialoge', via: :post

  match 'mark_important' => 'messages#mark_important', via: :post
  #match 'important_message' => 'messages#important_message', via: :post

  match 'delete_message' => 'messages#delete_message', via: :post
  #match 'delete_message' => 'messages#delete_message', via: :post

  match 'delete_one_dialogue' => 'messages#delete_one_dialogue', via: :post

  match 'spam_dialoge' => 'messages#spam_dialoge', via: :get
  #match 'spam_dialoge' => 'messages#spam_dialoge', via: :post

  # get "new_profile/get_profile_params"
  # get "new_profile/make_new_profile"
  # get "new_profile/make_tree_row"
  # get "new_profile/make_profilekeys_rows"
  # get "graph_tree/show_graph_tree"
  # get "graph_tree/edit"
  # get "graph_tree/move"
  # get "admin_methods/service_method_1"
  # get "admin_methods/service_method_2"
  # mount RailsAdmin::Engine => '/admin_gem', :as => 'rails_admin'


  # admin_methods controller
  # match 'service_method_1' => 'admin_methods#service_method_1', via: :get
  # match 'service_method_1' => "admin_methods#service_method_1", via: :post
  # match 'service_method_2' => 'admin_methods#service_method_2', via: :get
  # match 'service_method_2' => "admin_methods#service_method_2", via: :post


  # pages controller
  match 'landing' => 'pages#landing', via: :get
  match 'news' => 'pages#news', via: :get
  match 'mail' => 'pages#mail', via: :get
  match 'mypage' => 'pages#mypage', via: :get
  match 'search' => 'pages#search', via: :get
  match 'conversation' => 'pages#conversation', via: :get
  match 'start_enter' => 'pages#start_enter', via: :get
  match 'start_dialoge' => 'pages#start_dialoge', via: :get # запуск процесса диалогового ввода стартового древа

  #todo: убрать путаницу в названиях методов main и start
  # main controller
  match 'main_page' => 'main#main_page', via: [:get, :post]
  match 'search_tree_match' => 'main#search_tree_match', via: :get
  match 'relative_menu' =>   'main#relative_menu', via: :get
  match 'match_approval' => 'main#match_approval', via: :get
  match 'add_new_profile' => 'new_profile#add_new_profile', via: [:get, :post]

  # start controller
  #####################
  # match 'show_tree_table' => 'start#show_tree_table', via: :get
  # match 'display_saved_tree' => 'start#display_saved_tree', via: :get
  # match 'save_start_tables' => 'start#save_start_tables', via: :get

  # start controller # "enters"
  # match 'enter_myself' => 'start#enter_myself', via: :get
  # match 'enter_father' => 'start#enter_father', via: :get
  # match 'enter_mother' => 'start#enter_mother', via: :get
  # match 'enter_brother' => 'start#enter_brother', via: :get
  # match 'enter_sister' => 'start#enter_sister', via: :get
  # match 'enter_son' => 'start#enter_son', via: :get
  # match 'enter_daugther' => 'start#enter_daugther', via: :get
  # match 'enter_husband' => 'start#enter_husband', via: :get
  # match 'enter_wife' => 'start#enter_wife', via: :get
  # match 'enter_final' => 'start#enter_final', via: :get

  # start controller # "checks"
  # match 'check_brothers' => 'start#check_brothers', via: :post
  # match 'check_sisters' => 'start#check_sisters', via: :post
  # match 'check_sons' => 'start#check_sons', via: :post
  # match 'check_daugthers' => 'start#check_daugthers', via: :post
  # match 'check_husband' => 'start#check_husband', via: :post
  # match 'check_wife' => 'start#check_wife', via: :post

  # start controller # "stores"
  # match 'store_myself' => 'start#store_myself', via: :post
  # match 'store_father' => 'start#store_father', via: :post
  # match 'store_mother' => 'start#store_mother', via: :post
  # match 'store_brother' => 'start#store_brother', via: :post
  # match 'store_sister' => 'start#store_sister', via: :post
  # match 'store_son' => 'start#store_son', via: :post
  # match 'store_daugther' => 'start#store_daugther', via: :post
  # match 'store_husband' => 'start#store_husband', via: :post
  # match 'store_wife' => 'start#store_wife', via: :post

  # new_profile controller
  match 'make_new_profile' => 'new_profile#make_new_profile', via: :get
  match 'make_tree_row' => 'new_profile#make_tree_row', via: :get
  match 'make_profilekeys_rows' => 'new_profile#make_profilekeys_rows', via: :get
  match 'add_new_profile' => 'new_profile#add_new_profile', via: :get
  match 'add_new_profile' => 'new_profile#add_new_profile', via: :post


  # connect_users_trees controller
  match 'connection_of_trees' => 'connect_users_trees#connection_of_trees', via: :get
  match 'get_trees_to_connect' => 'connect_users_trees#get_trees_to_connect', via: :get
  match 'connect_users' => 'connect_users_trees#connect_users', via: :get
  match 'connect_profiles' => 'connect_users_trees#connect_profiles', via: :get
  match 'connect_trees' => 'connect_users_trees#connect_trees', via: :get
  match 'connect_profiles_keys' => 'connect_users_trees#connect_profiles_keys', via: :get

  get "connect_users_trees/connect_users"
  get "connect_users_trees/connect_profiles"
  get "connect_users_trees/connect_trees"
  get "connect_users_trees/connect_profiles_keys"





  # resources :profiles, except: [:index, :edit]
  # resources :profiles, except: [:index, :edit] do
      # get 'show-dropdowm-menu', to: 'profiles#show_dropdown_menu', as: :show_dropdown
      # get 'show-context-menu', to: 'profiles#show_context_menu', as: :show_context_menu
      # get '/edit/data', to: 'profiles#edit', as: :edit_data
  # end

  get 'profile/context-menu', to: 'profiles#context_menu', as: :profile_context_menu

  resources :profiles, except: [:index, :edit] do
    get '/edit/data', to: 'profiles#edit', as: :edit_data
    get '/version/:profile_data_id', to: 'profiles#show', as: :profile_data_version
  end


  # Profile Data
  ##################################################
  resources :profile_datas, only: [:update, :create]





  # for Mailer
  match 'enter_email' => 'profiles#enter_email', via: :get
  match 'enter_email' => 'profiles#enter_email', via: :post

  match 'invitation_email' => 'weafam_mailer#invitation_email', via: :get
  match 'invitation_email' => 'weafam_mailer#invitation_email', via: :post



  resources :relations



  # Send invite email
  resources :invites, only: [:new, :create]


  # Debug path - Login as user
  get 'login_as_user/:user_id',             to: 'welcome#login_as_user',       as: :login_as_user


  # Users Sessions Signup
  ##################################################
  resources :users


  resources :sessions, except: :edit
  get  'login',      to:   "sessions#new",      as: :login
  get  'logout',     to:   "sessions#destroy",  as: :logout
  get  'signup',     to:   'signup#index',      as: :signup
  post 'register',   to:   'signup#create',     as: :register
  get  'pending',    to:   'signup#pending',   as: :pending




  # Home
  ##################################################
  get '/home',        to: 'home#index',  as: :home
  get '/home/search', to: 'home#search', as: :home_search



  # Autocompletes
  ##################################################
  get '/autocomplete/names', to: 'autocomplete#names'


  # Names
  ##################################################
  # resources :names
  get '/names/find', to: "names#find", as: :find_name



  # API
  ##################################################
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get 'circles', to: 'circles#show'
      get 'search',  to: 'search#index'
    end
  end



  # Admin
  ##################################################
  namespace :admin do

    resources :sessions
    get '/login'  => 'sessions#new',      :as => :login
    get '/logout' => 'sessions#destroy',  :as => :logout


    resources :admins
    resources :users do
      post 'login_as/:user_id', to: 'users#login_as', as: :login_as_user
    end

    resources :resets, only: [:new, :create]

    resources :pending_users do
      get 'blocked',    to: 'pending_users#blocked',    as: :blocked, on: :collection
      get 'approved',    to: 'pending_users#approved',  as: :approved, on: :collection
      get 'block',      to: 'pending_users#block',      as: :block
      get 'reset',      to: 'pending_users#reset',      as: :reset
      post 'approve',   to: 'pending_users#approve',    as: :approve
    end


    resources :names do
      get 'males',   to: "names#males",   on: :collection, as: :males
      get 'females', to: "names#females", on: :collection, as: :females
    end

    resources :subnames


    root "users#index"
  end





  # Root
  ##################################################
  root  'welcome#index'

end
