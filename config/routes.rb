Weafam::Application.routes.draw do


  resources :similars_founds, except: [:update, :show, :edit]

  resources :relations

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
  match 'internal_similars_search' => 'similars#internal_similars_search', via: :get
  match 'show_similars_data' => 'similars#show_similars_data', via: :get
  match 'show_similars_data' => 'similars#show_similars_data', via: :post
  get 'similars/index'
  match 'connect_similars' => 'similars#connect_similars', via: :get
  match 'keep_disconnected_similars' => 'similars#keep_disconnected_similars', via: :get
  match 'connect_similars' => 'similars#connect_similars', via: :post
  match 'keep_disconnected_similars' => 'similars#keep_disconnected_similars', via: :post
  match 'disconnect_similars' => 'similars#disconnect_similars', via: :get
  match 'disconnect_similars' => 'similars#disconnect_similars', via: :post
  match 'check_connected_similars' => 'similars#check_connected_similars', via: :get
  match 'check_connected_similars' => 'similars#check_connected_similars', via: :post

  # CommonLog controller
  resources :common_logs, except: [:update, :edit, :show]

  get 'common_logs/index'
  # match 'connect_similars' => 'similars_founds#connect_similars', via: :get
  get 'common_logs/create'
  # get 'common_logs/show'
  get 'common_logs/destroy'
  match 'rollback_logs' => 'common_logs#rollback_logs', via: :post
  match 'rollback_logs' => 'common_logs#rollback_logs', via: :get
  match 'mark_rollback' => 'common_logs#mark_rollback', via: :post
  match 'mark_rollback' => 'common_logs#mark_rollback', via: :get


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


  get 'profile/context-menu', to: 'profiles#context_menu', as: :profile_context_menu

  resources :profiles, except: [:index, :edit] do
    get '/edit/data', to: 'profiles#edit', as: :edit_data
    get '/version/:profile_data_id', to: 'profiles#show', as: :profile_data_version
  end

  match '/profiles/avatar', to: 'avatar#upload', as: :upload_avatar, via: [:get, :post]

  get '/crop/avatar/:profile_id', to: 'profiles#crop', as: :crop_avatar


  # Profile Data
  ##################################################
  resources :profile_datas, only: [:update, :create]


  match '/passwrod/reset' => 'password#reset', via: [:get, :post], as: :reset_password


  # for Mailer
  match 'enter_email' => 'profiles#enter_email', via: :get
  match 'enter_email' => 'profiles#enter_email', via: :post

  match 'invitation_email' => 'weafam_mailer#invitation_email', via: :get
  match 'invitation_email' => 'weafam_mailer#invitation_email', via: :post


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

  match 'show_similars' => 'home#show_similars', via: :post

  # Autocompletes
  ##################################################
  get '/autocomplete/names', to: 'autocomplete#names'


  # Names
  ##################################################
  # resources :names
  get '/names/find', to: "names#find", as: :find_name
  # add new name (from user)
  resources :names, only: [:new, :create]



  # API
  ##################################################
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get 'circles', to: 'circles#show'
      get 'search',  to: 'search#index'
      get 'search/iternal',  to: 'search#iternal'
    end
  end


  # Meteor
  ##################################################
  namespace :meteor, defaults: {format: 'json'} do
    namespace :v1 do

      get :login, to: 'login#login'


      namespace :validations do
        namespace :emails do
          get :exist, to: "emails#exist"
        end
      end


      namespace :signup do
        get :create, to: 'signup#create'
        get :test, to: 'signup#test'
      end


      namespace :passwords do
        get :reset, to: 'passwords_reset#reset'
      end


      namespace :profiles do
        get :destroy, to: "profiles_destroy#destroy"
        get :create,  to: "profiles_create#create"
      end


      namespace :names do
        get :create,  to: "names_create#create"
      end

      namespace :common_logs do
        get :rollback, to: "rollbacks#rollback"
      end

      namespace :connection_requests do
        get :no_connect, to: "no_connect#no_connect"
        get :yes_connect, to: "yes_connect#yes_connect"
        get :make_request, to: "make_request#make_request"
      end

      namespace :search_results do
        get :search, to: "search_results#search"
      end

      namespace :similars_founds do
        get :search_similars, to: "similars_founds#search_similars"
      end

      namespace :similars_connection do
        get :connecting_similars, to: "similars_connection#connecting_similars"
      end

      namespace :profile_datas do
        get :update, to: "profile_datas_update#update"
      end

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
      get 'approved',   to: 'pending_users#approved',  as: :approved, on: :collection
      get 'block',      to: 'pending_users#block',      as: :block
      get 'reset',      to: 'pending_users#reset',      as: :reset
      post 'approve',   to: 'pending_users#approve',    as: :approve
    end


    resources :names do
      get 'males',   to: "names#males",   on: :collection, as: :males
      get 'females', to: "names#females", on: :collection, as: :females
      get 'pending', to: "names#pending", on: :collection, as: :pending
    end

    resources :subnames

    root "users#index"
  end



  # Root
  ##################################################
  root  'welcome#index'

end
