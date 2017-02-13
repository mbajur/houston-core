Rails.application.routes.draw do

  devise_for :users, :controllers => { :sessions => "sessions" }

  root to: "teams#index", via: :get



  # Teams

  resources :teams

  scope "teams/:team_id" do
    resources :projects, only: [:new]
  end



  # Projects

  resources :projects, except: [:new] do
    member do
      put :retire
    end

    post "follow", to: "project_roles#create", :as => :follow
    delete "unfollow", to: "project_roles#destroy", :as => :unfollow
  end



  # Users

  constraints :id => /\d+/ do
    resources :users do
      member do
        post :invite
      end
    end
  end



  # Uploads

  post "uploads/policies", to: "uploads#policies"



  # API

  namespace "api" do
    namespace "v1" do
      get "projects", to: "projects#index"

      get "measurements", to: "measurements#index"
    end
  end



  # Authorizations

  put "credentials", to: "user_credentials#upsert"
  delete "credentials/:id", to: "user_credentials#destroy"

  get "authorizations" => "authorizations#index", as: :authorizations
  get "authorizations/new" => "authorizations#new", as: :new_authorization
  post "authorizations" => "authorizations#create"
  get "authorizations/:id/edit" => "authorizations#edit", as: :edit_authorization
  patch "authorizations/:id" => "authorizations#update", as: :authorization

  get "authorizations/:id/grant" => "authorizations#grant", as: :grant_authorization
  get "authorizations/:id/granted" => "authorizations#granted", as: :authorization_granted
  get "oauth2/callback" => "authorizations#oauth2_callback", as: :oauth2_callback

  get "oauth/providers" => "oauth/providers#index", as: :oauth_providers
  get "oauth/providers/new" => "oauth/providers#new", as: :new_oauth_provider
  post "oauth/providers" => "oauth/providers#create"
  get "oauth/providers/:id/edit" => "oauth/providers#edit", as: :edit_oauth_provider
  patch "oauth/providers/:id" => "oauth/providers#update", as: :oauth_provider



  # Actions

  get "actions", to: "actions#index", as: :actions
  get "actions/running", to: "actions#running", as: :running_actions
  get "actions/:slug", to: "actions#show", as: :action, constraints: { slug: /[^\/]+/ }
  post "actions/:slug", to: "actions#run", as: :run_action, constraints: { slug: /[^\/]+/ }
  post "actions/:id/retry", to: "actions#retry", as: :retry_action



  # Triggers

  get "triggers", to: "triggers#index", as: :triggers



  # Errors

  get "errors", to: "errors#index", as: :errors



  # Options

  put "projects/:slug/options", to: "project_options#update"
  delete "projects/:slug/options/:key", to: "project_options#destroy"

  put "options", to: "user_options#update"
  delete "options/:key", to: "user_options#destroy"



  # Tester Bar
  match "tester_bar/:action", :controller => "tester_bar", via: [:get, :post] if Rails.env.development?



  # The Instance
  # (before Modules so that it can override routes in the modules)

  if defined?(Houston::Engine)
    mount Houston::Engine => "/"
  end



  # Modules

  Houston.config.modules.each do |mod|
    mount mod.engine => "/"
  end



  # Web Hooks
  # (at the bottom, allows modules or instances to define specific hooks)

  post "hooks/:hook", to: "hooks#trigger"

  scope "projects/:project_id" do
    constraints :hook => /[\w\d\-_]+/ do
      get "hooks/:hook", to: "project_hooks#trigger", :as => :web_hook
      post "hooks/:hook", to: "project_hooks#trigger"
    end
  end

end
