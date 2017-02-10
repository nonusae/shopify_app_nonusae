class TagsController < ShopifyApp::AuthenticatedController

before_action :check_or_create_shopify_shop

	def update_multiple
	  @tags = Tag.find(params[:tag_ids])
	  @tags.each do |tag|
	  	id = tag.id.to_s
	  	puts params[:tags][id]["thai_title"]
	    tag.update_attribute(:thai_title,params[:tags][id]["thai_title"])
	  end
	  redirect_to root_path
	end

	def get_all_translated_tag
		@tag = Tag.all
		respond_to do |format|
			format.json { render :json => @tag }
		end 
	end

	def get_translated_tag
		t = params[:tags].split(",") # use this instead of where for correct order
		@tag= []
		t.each do |tt|
			tag = Tag.find_by_title(tt)
			@tag << tag
		end
		puts params[:tags].split(",")
		respond_to do |format|
			format.json { render :json => @tag }
		end 		
	end

private

  def check_or_create_shopify_shop
  	puts "1111212321321123"
  	  	shop_domain = ShopifyAPI::Shop.current.domain
  	  	puts shop_domain
  	  	unless @shop = ShopifyShop.find_by_shop_domain(shop_domain)
  	  		shop = ShopifyShop.new
  	  		shop.shop_domain = shop_domain
  	  		shop.save
  	  		@shop = ShopifyShop.find_by_shop_domain(shop_domain)
  	  	end
  end	

end