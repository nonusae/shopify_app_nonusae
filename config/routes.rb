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

  get 'update_tags' => 'admin/dashboard#update_tags'
  get 'proxy' => 'proxy#index'
  
  namespace :admin do
    resources :dashboard
  end
end
