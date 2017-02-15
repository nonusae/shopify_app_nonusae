class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  before_action :check_or_create_shopify_shop, :asset_check

  def index
  if @shop.present?  
 	  @tag = @shop.tags.all
  else
    puts "shop not present"
    @tag = []
  end

  end

  def update_tags
    shop_domain  = params[:shop]
    @shop = ShopifyShop.find_by_shop_domain(shop_domain)
  	tag_raw = HTTParty.get("http://#{shop_domain}/search?view=tags").body
    tag_from_soruce = JSON.parse(tag_raw)
    tag_from_soruce.each do |tag|
    	unless @shop.tags.find_by_title(tag)
    		unless tag == ""
    			t = Tag.new
    			t.shopify_shop = @shop
    			t.title = tag
    			t.thai_title = ""
    			t.save
    		end
    	end

    database_tags = @shop.tags.map(&:title)
    puts "DATABASE TAGS = #{database_tags}"
    puts "TAG FROM SOURCE = #{tag_from_soruce}"
    database_tags.each do |d_tag|
      unless tag_from_soruce.include?(d_tag)
        puts "D TAG is #{d_tag}"
        tag = @shop.tags.find_by_title(d_tag)
        tag.destroy if tag.present?
      end
    end

    end

    redirect_to root_path(:shop => shop_domain)
  end

  def check_or_create_shopify_shop
      if params[:shop].present?
  	  	shop_domain = params[:shop]
        puts "!!!!!!!! SHOP  PRESENT THIS ROUND !!!!"
    	  	unless @shop = ShopifyShop.find_by_shop_domain(shop_domain)
    	  		if shop_domain.present?
              shop = ShopifyShop.new
      	  		shop.shop_domain = shop_domain
      	  		shop.save
      	  		@shop = ShopifyShop.find_by_shop_domain(shop_domain)
            end
    	  	end
      else
        puts "SHOP IS NOT PRESENT THIS ROUND"
      end
  end

  def asset_check
    begin
      asset   = ShopifyAPI::Asset.find('templates/search.tags.liquid')
    rescue
      asset = nil
      new_asset = ShopifyAPI::Asset.create(key: 'templates/search.tags.liquid', src: 'https://rawgit.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/search.tags.liquid')
    end   
  end

end
