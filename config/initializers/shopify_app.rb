ShopifyApp.configure do |config|
  config.api_key = Rails.configuration.shopify_api_key
  config.secret = Rails.configuration.shopify_secret
  config.scope = "read_content,write_content,read_themes,write_themes,read_products,write_products,read_customers,write_customers,read_orders,write_orders,read_script_tags,write_script_tags,read_fulfillments,write_fulfillments,read_shipping,write_shipping"
  config.embedded_app = true
  config.scripttags = [
  # {event:'onload', src: 'https://rawgit.com/nonusae/shopify_app_nonusae/master/app/assets/javascripts/test_script37.js'}
    {event:'onload', src: 'https://cdn.rawgit.com/nonusae/shopify_app_nonusae/3b1e0a4e/app/assets/javascripts/test_script41.js'}
]
end
