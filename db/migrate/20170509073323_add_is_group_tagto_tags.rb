class AddIsGroupTagtoTags < ActiveRecord::Migration
  def change
  	    add_column :tags, :is_group_tag, :boolean
  	    add_column :tags, :group_tag_cat, :string
  	    add_column :tags, :group_tag_sub, :string

  end
end
