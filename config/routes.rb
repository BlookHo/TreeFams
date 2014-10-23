Weafam::Application.routes.draw do
  get "connect_users_trees/connect_users"
  get "connect_users_trees/connect_profiles"
  get "connect_users_trees/connect_trees"
  get "connect_users_trees/connect_profiles_keys"
  get "new_profile/get_profile_params"
  get "new_profile/make_new_profile"
  get "new_profile/make_tree_row"
  get "new_profile/make_profilekeys_rows"
  get "graph_tree/show_graph_tree"
  get "graph_tree/edit"
  get "graph_tree/move"
  get "admin_methods/service_method_1"
  get "admin_methods/service_method_2"
  # mount RailsAdmin::Engine => '/admin_gem', :as => 'rails_admin'


  # admin_methods controller
  match 'service_method_1' => 'admin_methods#service_method_1', via: :get
  match 'service_method_1' => "admin_methods#service_method_1", via: :post
  match 'service_method_2' => 'admin_methods#service_method_2', via: :get
  match 'service_method_2' => "admin_methods#service_method_2", via: :post


  # pages controller
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
  match 'main_page' => 'main#main_page', via: [:get, :post]
  match 'search_tree_match' => 'main#search_tree_match', via: :get
  match 'relative_menu' =>   'main#relative_menu', via: :get
  match 'match_approval' => 'main#match_approval', via: :get
  match 'add_new_profile' => 'new_profile#add_new_profile', via: [:get, :post]

  # graph_tree controller
  match 'show_graph_tree' => 'graph_tree#show_graph_tree', via: :get
  match 'edit_graph_tree' => 'graph_tree#edit_graph_tree', via: :get
  match 'move_graph_tree' => 'graph_tree#move_graph_tree', via: :get

  # start controller
  #####################
  match 'show_tree_table' => 'start#show_tree_table', via: :get
  match 'display_saved_tree' => 'start#display_saved_tree', via: :get
  match 'save_start_tables' => 'start#save_start_tables', via: :get

  # start controller # "enters"
  match 'enter_myself' => 'start#enter_myself', via: :get
  match 'enter_father' => 'start#enter_father', via: :get
  match 'enter_mother' => 'start#enter_mother', via: :get
  match 'enter_brother' => 'start#enter_brother', via: :get
  match 'enter_sister' => 'start#enter_sister', via: :get
  match 'enter_son' => 'start#enter_son', via: :get
  match 'enter_daugther' => 'start#enter_daugther', via: :get
  match 'enter_husband' => 'start#enter_husband', via: :get
  match 'enter_wife' => 'start#enter_wife', via: :get
  match 'enter_final' => 'start#enter_final', via: :get

  # start controller # "checks"
  match 'check_brothers' => 'start#check_brothers', via: :post
  match 'check_sisters' => 'start#check_sisters', via: :post
  match 'check_sons' => 'start#check_sons', via: :post
  match 'check_daugthers' => 'start#check_daugthers', via: :post
  match 'check_husband' => 'start#check_husband', via: :post
  match 'check_wife' => 'start#check_wife', via: :post

  # start controller # "stores"
  match 'store_myself' => 'start#store_myself', via: :post
  match 'store_father' => 'start#store_father', via: :post
  match 'store_mother' => 'start#store_mother', via: :post
  match 'store_brother' => 'start#store_brother', via: :post
  match 'store_sister' => 'start#store_sister', via: :post
  match 'store_son' => 'start#store_son', via: :post
  match 'store_daugther' => 'start#store_daugther', via: :post
  match 'store_husband' => 'start#store_husband', via: :post
  match 'store_wife' => 'start#store_wife', via: :post

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




  resources :members, except: :index
  resources :trees
  resources :profiles, except: [:index, :edit] do
    get 'show-dropdowm-menu', to: 'profiles#show_dropdown_menu', as: :show_dropdown
    get '/edit/data', to: 'profiles#edit', as: :edit_data
  end

  resources :users
  resources :names
  resources :relations


  get 'main/circles/(:path)',                          to: "circles#show",            as: :circle
  get 'search/circles/:path_id/:tree_id/(:path)',               to: "circles#show_search",     as: :search_circle
  get 'search/circle_path/:path_id/:tree_id/(:path)',  to: "circles#show_search_path", as: :search_circle_path


  # Landing & start singup
  get    'welcome/start',                  to: 'welcome#start',                as: :start
  match  'welcome/start/proceed',          to: 'welcome#proceed',              as: :proceed_start, via: [:get, :post]
  get    'welcome/start/to/step/:step',    to: 'welcome#to_step',              as: :to_start_step
  get    'welcome/start/step/previous',    to: 'welcome#previous',             as: :previous
  get    'welcome/start/add/:member',      to: 'welcome#add_member_field',     as: :add_member_field
  # get    'welcome/start/show_data',        to: 'welcome#show_data',            as: :show_data

  # Debug path - Login as user
  get 'login_as_user/:user_id',             to: 'welcome#login_as_user',       as: :login_as_user



  # New version
  ##################################################
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get 'circles', to: 'circles#show'
      get 'search',  to: 'search#index'
    end
  end


  # New version
  ##################################################

  # Users Sessions Signup
  resources :sessions, except: :edit
  get  'login',      to:   "sessions#new",      as: :login
  get  'logout',     to:   "sessions#destroy",  as: :logout
  get  'signup',     to:   'signup#index',      as: :signup
  post 'register',   to:   'signup#create',     as: :register


  # Home
  ##################################################
  get '/home', to: 'home#index', as: :home


  # Autocompletes
  ##################################################
  get '/autocomplete/names', to: 'autocomplete#names'

  # Root
  ##################################################
  root  'welcome#index'

end
