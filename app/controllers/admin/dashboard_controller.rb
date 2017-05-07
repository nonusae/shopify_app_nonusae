class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  before_action :check_or_create_shopify_shop, :asset_check, :check_billing

  def index
    # @error_msg = nil
    if @shop.present?

      if @shop.shop_domain == "nonusae-app.myshopify.com"
        console
      end

      if ((@new_user) && !(@shop.shop_domain == "nonusae-app.myshopify.com") && !(@shop.shop_domain == "thaidiycupcake.myshopify.com") ) #(@shop.shop_domain == "nonusae-app.myshopify.com")
        puts "NEW USer !!!!!"
        recurring_application_charge_params = {
                                          "name": "Products Tag Traslator Subscription",
                                          "price": 9.99,
                                          "trial_days": 7
                                        
        }
        @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new(recurring_application_charge_params)
        @recurring_application_charge.test = false
        @recurring_application_charge.return_url = callback_recurring_application_charge_url
        puts "Chrage OK!!"
        if @recurring_application_charge.save
          puts @recurring_application_charge.confirmation_url
          render :layout => false, :inline => "<script>window.top.location = '#{@recurring_application_charge.confirmation_url}&shop_domain=#{@shop.shop_domain}';</script>"
        else
          flash[:danger] = @recurring_application_charge.errors.full_messages.first.to_s.capitalize
          redirect_to_correct_path(@recurring_application_charge)
        end    
      end

      def callback
        @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(params[:charge_id])
        if @recurring_application_charge.status == 'accepted'
          @recurring_application_charge.activate
        end

        redirect_to_correct_path(@recurring_application_charge)
      end      


      # @error_msg = update_tag_no_redirect(@shop)
      # @error_msg = params[:error] if params[:error].present?
      puts @error_msg if @error_msg.present?
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
    
      begin
        tag_from_soruce = JSON.parse(tag_raw)
        @error_msg = nil
      rescue
        tag_from_soruce = []
        @error_msg = "ERROR SHOP WITH PASSWORD"
      end

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
      new_asset = ShopifyAPI::Asset.create(key: 'templates/search.tags.liquid', src: 'https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/search.tags.liquid')
    end   
  end

  def theme_check
      @shop_domain = params[:shop] if params[:shop].present?
      puts "THEME ENABLED"
      themes = ShopifyAPI::Theme.all
      current_theme_id = nil
      current_theme_name = nil
      themes.each do |theme|
        theme_j = theme.as_json
        if theme_j["role"] == "main"
          current_theme_id = theme_j["id"]
          current_theme_name = theme_j["name"]
        end
      end 
      puts "Theme name is : " + current_theme_name ##


      if current_theme_name == "Venture"
        begin
           file_to_overwrite = ShopifyAPI::Asset.create(key: 'sections/collection-filters.liquid', src: 'https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/themes_asset/venture/collection-filters.liquid')
        rescue
          puts "error occure whild overite theme"
        end
      elsif current_theme_name == "Supply"
        begin
          file_to_overwrite = ShopifyAPI::Asset.create(key: 'snippets/collection-filters.liquid', src: 'https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/themes_asset/supply/collection-filters.liquid')
        rescue
          puts "error occure whild overite theme"
        end        
      elsif current_theme_name == "Debut"
        begin
          file_to_overwrite = ShopifyAPI::Asset.create(key: 'sections/collection-template.liquid', src: 'https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/themes_asset/debut/collection-template.liquid')
        rescue
          puts "error occure whild overite theme"
        end
      elsif current_theme_name == "Simple"
        begin
          file_to_overwrite = ShopifyAPI::Asset.create(key: 'sections/collection-template.liquid', src: 'https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/themes_asset/simple/collection-template.liquid')
        rescue
          puts "error occure whild overite theme"
        end
      elsif current_theme_name == "Brooklyn"
        begin
          file_to_overwrite = ShopifyAPI::Asset.create(key: 'snippets/collection-template.liquid', src: "https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/themes_asset/brooklyn/collection-template.liquid")
        rescue
          puts "error occure whild overite theme"
        end
      elsif current_theme_name == "Pop"
        begin
          file_to_overwrite = ShopifyAPI::Asset.create(key: 'snippets/collection-tags.liquid', src: 'https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/themes_asset/pop/collection-tags.liquid')
        rescue
          puts "error occure whild overite theme"
        end
      elsif current_theme_name == "Minimal"
        begin
          file_to_overwrite = ShopifyAPI::Asset.create(key: 'snippets/collection-tags.liquid', src: 'https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/themes_asset/minimal/collection-tags.liquid')
        rescue
          puts "error occure whild overite theme"          
        end
      elsif current_theme_name == "Boundless"
        begin
          file_to_overwrite = ShopifyAPI::Asset.create(key: 'sections/collection-template.liquid', src: "https://raw.githubusercontent.com/nonusae/shopify_app_nonusae/master/app/assets/shopify_asset/themes_asset/boundless/collection-template.liquid")
        rescue
          puts "error occure whild overite theme"          
        end 

      end
      redirect_to root_path(shop: @shop_domain)          
  end

  def instructions
    @shop_domain = params[:shop]
  end

private

 def update_tag_no_redirect(shop)
      puts "ssssssssssssssss"
      @shop = shop
      shop_domain = @shop.shop_domain
      tag_raw = HTTParty.get("http://#{shop_domain}/search?view=tags").body

      begin
        tag_from_soruce = JSON.parse(tag_raw)
      rescue
        return "ERROR SHOP WITH PASSWORD"
      end

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
      return nil
 end

 def check_billing
    bill = ShopifyAPI::RecurringApplicationCharge.current
    puts bill.to_s
    if bill.present?
      @new_user = false
    else
      @new_user = true
    end
 end

 def redirect_to_correct_path(recurring_application_charge)
    if recurring_application_charge.try(:capped_amount)
      redirect_to usage_charge_path
    else
      redirect_to recurring_application_charge_path
    end
 end

end



