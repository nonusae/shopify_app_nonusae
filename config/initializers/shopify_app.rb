ShopifyApp.configure do |config|
  config.api_key = Rails.configuration.shopify_api_key
  config.secret = Rails.configuration.shopify_secret
  config.scope = "read_content,write_content,read_themes,write_themes,read_products,write_products,read_customers,write_customers,read_orders,write_orders,read_script_tags,write_script_tags,read_fulfillments,write_fulfillments,read_shipping,write_shipping"
  config.embedded_app = true
  config.scripttags = [
  {event:'onload', src: 'https://www.dropbox.com/s/jg99fnjys5myvua/test_script.js'}
]
end
