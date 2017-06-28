
# Starter App

Used to get a quickstart on a public Shopify app. Follow instructions here: 

http://demacmedia.com/blog/shopify-pp

## Config

- Shopify_app must be configured correctly to run
- the relevant config variables are inherited from /config/environments/development.rb

## Controllers

- Admin::DashbordController inherits from ShopifyApp::AuthenticatedController
	- all admin controllers should inherit from ShopifyApp::AuthenticatedController
- ProxyController controls the front-end application proxy views
	- front-end controllers should not inherit from ShopifyApp::AuthenticatedController

## Assets

- turbolinks disabled by default
- don't need all that AJAX jazz happening inside the Shopify admin panel -- messes with deep-linking


## How to Use Custom Task

 - For import product from Shopify Using shopify api. Enter command in following format in terminal
``Ruby
rake product_tasks:import_products[no_of_product]
``
