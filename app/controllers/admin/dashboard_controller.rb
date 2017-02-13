class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  before_action :check_or_create_shopify_shop, :asset_check

  def index
 	@tag = @shop.tags.all  
  end

  def update_tags
  	shop_domain = ShopifyAPI::Shop.current.domain
  	tag_raw = HTTParty.get("http://#{shop_domain}/search?view=tags").body
    tag_from_soruce = JSON.parse(tag_raw)
    tag_from_soruce.each do |tag|
    	unless Tag.find_by_title(tag)
    		unless tag == ""
    			t = Tag.new
    			t.shopify_shop = @shop
    			t.title = tag
    			t.thai_title = ""
    			t.save
    		end
    	end
    end
    redirect_to root_path
  end

  def check_or_create_shopify_shop
  	  	shop_domain = ShopifyAPI::Shop.current.domain
  	  	unless @shop = ShopifyShop.find_by_shop_domain(shop_domain)
  	  		shop = ShopifyShop.new
  	  		shop.shop_domain = shop_domain
  	  		shop.save
  	  		@shop = ShopifyShop.find_by_shop_domain(shop_domain)
  	  	end
  end

  def asset_check
    begin
      asset   = ShopifyAPI::Asset.find('templates/search.tags.liquid')
    rescue
      asset = nil
      new_asset = ShopifyAPI::Asset.create(key: 'templates/search2.tags.liquid', src: 'https://rawgit.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/search.tags.liquid')
    end   
  end

end
