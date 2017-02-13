class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  before_action :check_or_create_shopify_shop

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
          ShopifyAPI::Asset.create(key: 'template/search.tags.liquid', src: 'https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/search.tags.liquid')
  	  		shop = ShopifyShop.new
  	  		shop.shop_domain = shop_domain
  	  		shop.save
  	  		@shop = ShopifyShop.find_by_shop_domain(shop_domain)
  	  	end
  end

end
