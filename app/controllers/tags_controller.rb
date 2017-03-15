class TagsController < ApplicationController


	def update_multiple
	  shop_domain = params[:shop]
	  @shop = ShopifyShop.find_by_shop_domain(shop_domain)
	  @tags = Tag.find(params[:tag_ids])
	  @tags.each do |tag|
	  	id = tag.id.to_s
	  	puts params[:tags][id]["thai_title"]
	    tag.update_attribute(:thai_title,params[:tags][id]["thai_title"])
	  end
	  redirect_to root_path(:shop => shop_domain)
	end

	def get_all_translated_tag
		@tag = Tag.all
		respond_to do |format|
			format.json { render :json => @tag }
		end 
	end

	def get_translated_tag
		@shop = ShopifyShop.find_by_shop_domain(params[:shop_domain])
		t = params[:tags].split(",") # use this instead of where for correct order
		@tag= []
		t.each do |tt|
			tag = @shop.tags.find_by_title(tt)
			tag = "" unless tag.present?
			@tag << tag
		end
		puts params[:tags].split(",")
		@tag.each do |a_tag|
			put a_tag.thai_title
		end
		respond_to do |format|
			format.json { render :json => @tag }
		end 		
	end


end