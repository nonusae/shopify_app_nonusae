class AddMoreColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products , :short_description , :string
    add_column :products , :model , :string
    add_column :products , :name_en , :string
    add_column :products , :seller_sku , :string
    add_column :products , :price , :string
    add_column :products , :package_content , :string
    add_column :products , :package_weight , :string
  end
end
