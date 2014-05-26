Weafam::Application.routes.draw do
  get "graph_tree/show_graph_tree"
  get "graph_tree/edit"
  get "graph_tree/move"
  get "admin_methods/service_method_1"
  get "admin_methods/service_method_2"
  mount RailsAdmin::Engine => '/admin_gem', :as => 'rails_admin'


  #


  resources :trees
  resources :profiles
  resources :users
  resources :names
  resources :relations

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
  match 'main_page' => 'main#main_page', via: :get
  match 'search_tree_match' => 'main#search_tree_match', via: :get
  match 'relative_menu' => 'main#relative_menu', via: :get
  match 'match_approval' => 'main#match_approval', via: :get

  # graph_tree controller
  match 'show_graph_tree' => 'graph_tree#show_graph_tree', via: :get
  match 'edit_graph_tree' => 'graph_tree#edit_graph_tree', via: :get
  match 'move_graph_tree' => 'graph_tree#move_graph_tree', via: :get

  # start controller
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


  # Landing & start singup
  get   'welcome/start',                 to: 'welcome#start',        as: :start
  match  'welcome/start/proceed',        to: 'welcome#proceed',      as: :proceed_start, via: [:get, :post]
  get   'welcome/start/to/step/:step',   to: 'welcome#to_step',      as: :to_start_step
  get   'welcome/start/step/previous',   to: 'welcome#previous',     as: :previous

  root  'welcome#index'

end
