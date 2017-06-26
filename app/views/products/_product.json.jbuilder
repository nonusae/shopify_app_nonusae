json.extract! product, :id, :shopify_id, :title, :description, :vendor, :handle, :created_at, :updated_at
json.url product_url(product, format: :json)