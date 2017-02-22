Rails.application.configure do

  config.public_url = 'https://shopify-tag-app.herokuapp.com/';
  
  # config.shopify_api_key = "1f5ffc34ded25b4cf826fb23ff939dde"
  # config.shopify_secret = "f5ef67554f9c267dac610559c0aa5274"

  config.shopify_api_key = "22ce8526cd1afaaca1975aa54a0d40e3"
  config.shopify_secret = "05b8159e8147c678d00072a0d7202739"

  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true


  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true




  config.log_level = :debug






  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new

  config.active_record.dump_schema_after_migration = false
end
