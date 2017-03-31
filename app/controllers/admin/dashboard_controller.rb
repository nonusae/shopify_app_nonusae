class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  before_action :check_or_create_shopify_shop, :asset_check, :check_billing

  def index

  if @shop.present?

    if @new_user
      puts "NEW USer !!!!!"
      recurring_application_charge_params = {
                                        "name": "Super Duper Plan",
                                        "price": 10.0,
                                        "trial_days": 1
                                      
      }
      @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new(recurring_application_charge_params)
      @recurring_application_charge.test = true
      @recurring_application_charge.return_url = "https://www."+@shop.shop_domain+"/admin"
      puts "Chrage OK!!"
      if @recurring_application_charge.save
        puts @recurring_application_charge.confirmation_url
        render :layout => false, :inline => "<script>window.top.location = '#{@recurring_application_charge.confirmation_url}';</script>"
      else
        flash[:danger] = @recurring_application_charge.errors.full_messages.first.to_s.capitalize
        redirect_to_correct_path(@recurring_application_charge)
      end    
    end  


    update_tag_no_redirect(@shop)
 	  @tag = @shop.tags.all.order("title ASC")
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
    # puts "DATABASE TAGS = #{database_tags}"
    # puts "TAG FROM SOURCE = #{tag_from_soruce}"
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


private

 def update_tag_no_redirect(shop)
      puts "ssssssssssssssss"
      @shop = shop
      shop_domain = @shop.shop_domain
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
      puts "DATABASE TAGS 2222= #{database_tags}"
      puts "TAG FROM SOURCE 22222= #{tag_from_soruce}"
      database_tags.each do |d_tag|
        unless tag_from_soruce.include?(d_tag)
          puts "D TAG is #{d_tag}"
          tag = @shop.tags.find_by_title(d_tag)
          tag.destroy if tag.present?
        end
      end

      end
 end

 def check_billing
    bill = ShopifyAPI::RecurringApplicationCharge.current
    unless bill.present?
      @new_user = false
    else
      @new_user = false
    end
 end
end