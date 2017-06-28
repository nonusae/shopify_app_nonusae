
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

### Import Pproducts

 - For import product from Shopify Using shopify api. Enter command in following format in terminal
 	- no_of_product =>  number of products you need to import (Enter 0 to import all products from output)
 	- page => page of the products in shopify product manager you want to select (Recomended value: 1) 
 	- colllection_id => Shopify collections id
 	- product_type => Shopify products_type 
 	- vendor => filter output by vendor

```ruby
rake product_tasks:import_products[no_of_product,page,collection_id,product_type,vendor]
```

 - For example if you to import 2 products from first page shopify store with  collection_id =3310. You have to enter following command

```ruby
rake product_tasks:import_products[2,1,3310]
```

### Upload products to Lazada

 - For upload products in database to lazada use following command

 ```ruby
rake product_tasks:upload_to_lazada
```

### Clear database

 - Uploading product to lazada task will upload all product in database to Lazada(If product is duplicated the uploader will skip it automatically). However I recommend to reset/clear our database everytime you want to upload new set products.

 ```ruby
rake product_tasks:clear 
```
