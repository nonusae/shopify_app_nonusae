Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  
  root :to => 'admin/dashboard#index'

  resources :tags do
  	collection do 
  		post 'update_multiple'
  		get 'get_all_translated_tag'
  		get 'get_translated_tag'
  	end
  end

  match "/admin/recurring_application_charges" => "recurring_application_charge#create"

  get 'update_tags' => 'admin/dashboard#update_tags'
  get 'proxy' => 'proxy#index'
  
  controller :sessions do
    get 'login' => :new, :as => :login
    post 'login' => :create, :as => :authenticate
    get 'auth/shopify/callback' => :callback
    get 'logout' => :destroy, :as => :logout
  end

  namespace :admin do
    resources :dashboard
  end

 resource :recurring_application_charge, only: [:show, :create, :destroy] do
    collection do
      get :callback
      post :customize
    end
  end


  resources :application_charges, only: [:index, :create] do
    member do
      post :activate
    end
  end

  resource :usage_charge, only: [:show, :create]

  resource :application_credit, only: [:show, :create, :index]  

end
