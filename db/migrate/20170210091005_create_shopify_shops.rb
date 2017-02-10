class CreateShopifyShops < ActiveRecord::Migration
  def change
    create_table :shopify_shops do |t|
      t.string :shop_domain

      t.timestamps null: false
    end
  end
end
