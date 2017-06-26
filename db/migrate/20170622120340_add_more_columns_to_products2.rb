class AddMoreColumnsToProducts2 < ActiveRecord::Migration
  def change
    add_column :products , :quantity , :string
  end
end
