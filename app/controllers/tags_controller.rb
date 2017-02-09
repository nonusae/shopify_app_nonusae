class TagsController < ApplicationController

	def update_multiple
	  @tags = Tag.find(params[:tag_ids])
	  @tags.each do |tag|
	    tag.update_attributes!(params[:tag])
	  end
	  redirect_to root_path
	end

end