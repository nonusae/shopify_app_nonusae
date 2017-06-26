class AddLazadaUrlToImages < ActiveRecord::Migration
  def change
    add_column :images , :lazada_url , :string 
  end
end
