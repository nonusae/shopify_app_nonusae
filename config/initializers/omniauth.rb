Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shopify,
    ShopifyApp.configuration.api_key,
    ShopifyApp.configuration.secret,
    scope: "read_content,write_content,read_themes,write_themes,read_script_tags,write_script_tags"
end
