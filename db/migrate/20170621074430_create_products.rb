class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :shopify_id
      t.string :title
      t.text :description
      t.string :vendor
      t.string :handle

      t.timestamps null: false
    end
  end
end
