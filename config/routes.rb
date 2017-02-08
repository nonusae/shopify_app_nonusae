Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  
  root :to => 'admin/dashboard#index'
  
  get 'proxy' => 'proxy#index'
  
  namespace :admin do
    resources :dashboard
  end
end
