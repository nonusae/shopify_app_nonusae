class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :img_url
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end
  end
end
