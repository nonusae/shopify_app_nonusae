class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  def index
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
 	@tag = Tag.all  
  end

  def update_tags
  	tag_raw = HTTParty.get('http://nonusae-app.myshopify.com/search?view=tags').body
    tag_from_soruce = JSON.parse(tag_raw)
    tag_from_soruce.each do |tag|
    	unless Tag.find_by_title(tag)
    		unless tag == ""
    			t = Tag.new
    			t.title = tag
    			t.thai_title = ""
    			t.save
    		end
    	end
    end
    redirect_to root_path
  end
end
