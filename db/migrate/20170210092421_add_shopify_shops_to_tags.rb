class AddShopifyShopsToTags < ActiveRecord::Migration
  def change
    add_reference :tags, :shopify_shop, index: true, foreign_key: true
  end
end
