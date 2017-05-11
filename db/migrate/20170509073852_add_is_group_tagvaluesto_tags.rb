class AddIsGroupTagvaluestoTags < ActiveRecord::Migration
  def change
  	  	add_column :tags, :group_tag_thai_cat, :string
  	    add_column :tags, :group_tag_thai_sub, :string  	
  end
end
