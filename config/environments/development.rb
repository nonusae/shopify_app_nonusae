Rails.application.configure do

  config.public_url = 'https://6480a30b.ngrok.io';
  
  config.shopify_api_key = "9cc5389f4a5d3486306ceb533377e50b"
  config.shopify_secret = "e41e0644198298e1d4d2f4de60ebc9ca"
  # config.scope = "read_content, write_content,read_themes, write_themes,read_products, write_products,read_customers, write_customers,read_orders, write_orders,read_script_tags, write_script_tags,read_fulfillments, write_fulfillments,read_shipping, write_shipping"

  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = false

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true

  config.assets.digest = true

  config.assets.raise_runtime_errors = true

end
