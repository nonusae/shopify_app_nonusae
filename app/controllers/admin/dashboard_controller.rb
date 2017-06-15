class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  before_action :check_or_create_shopify_shop, :asset_check, :check_billing

  def index
    @error_msg = nil
    @shop = ShopifyShop.find_by_shop_domain(params[:shop]) if params[:shop].present?
    if @shop.present?

      @shop_domain = @shop.shop_domain
      
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


      ## update all group tag boolen
        @shop.tags.all.each do |tag|
          if tag.is_group_tag == nil
            tag.update_is_group_tag_boolean
          end
        end
      ##


      # @error_msg = update_tag_no_redirect(@shop)
      @error_msg = params[:error] if params[:error].present?
      puts @error_msg if @error_msg.present?
      @normal_tag_no = @shop.tags.all.where("is_group_tag IS NOT true").count
   	  @tag = @shop.tags.all.order("is_group_tag ASC").order("title ASC")
      @cat_container = []
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
        error_msg = nil
      rescue
        tag_from_soruce = []
        error_msg = "ERROR SHOP WITH PASSWORD"
      end

    puts   tag_from_soruce
    tag_from_soruce.each do |tag|
    	unless @shop.tags.find_by_title(tag)
    		unless tag == ""
          puts "come in this loop"
    			t = Tag.new
    			t.shopify_shop = @shop
    			t.title = tag
    			t.thai_title = ""
          t.is_group_tag  = t.is_group_tag?
          if t.save
            if t.is_group_tag
              t.assign_group_tag_value
            end
          end

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

    redirect_to root_path(:shop => shop_domain,:error => error_msg)
  end

  def check_or_create_shopify_shop
      if params[:shop].present?
  	  	shop_domain = params[:shop]
        puts "!!!!!!!! SHOP  PRESENT THIS ROUND !!!!"
        puts "Email is " + ShopifyAPI::Shop.current.as_json.to_s
        shop_email = ShopifyAPI::Shop.current.email
        shop_name = ShopifyAPI::Shop.current.shop_owner

        MainAppMailer.sample_email("nonusae-app.myshopify.com",shop_email,shop_name).deliver if shop_domain == "nonusae-app.myshopify.com"
          unless @shop = ShopifyShop.find_by_shop_domain(shop_domain)
            if shop_domain.present?
              shop = ShopifyShop.new
      	  		shop.shop_domain = shop_domain
      	  		MainAppMailer.sample_email(shop_domain,shop_email,shop_name).deliver if shop.save
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


  def get_shopee_products_csv(page,mode)
    response = HTTParty.get("https://b7b232283836b5124bc13e40b1299be2:0f66356e3fd198115d2698a710db71f1@thaidiycupcake.myshopify.com/admin/products.json?page=#{page}").body
    json_res = JSON.parse(response)
    product_json = json_res["products"] # this is an array of product


    total = product_json.count
    CSV.open("file.csv", mode) do |csv|
        (-1..(total-1)).each do | i |
          if i == -1
            if mode == "wb"
              csv << ["เลข id หมวดหมู่สินค้า่",
              "ชื่อสินค้า่",
              "รายละเอียด",
              "่ราคา",
              "สินค้าคงคลัง",
              "น้ำหนักสินค้า",
              "ระยะเวลาเตรียมวัสดุ",
              "เลขอ้างอิงหน่วยสต็อกสินค้าหลัก(Parent SKU Reference No.)",
              "ตัวเลือกสินค้า 1: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 1: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 1: ราคา",
              "ตัวเลือกสินค้า 1: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 1: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 2: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 2: ราคา",
              "ตัวเลือกสินค้า 2: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 2: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 3: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 3: ราคา",
              "ตัวเลือกสินค้า 3: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 3: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 4: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 4: ราคา",
              "ตัวเลือกสินค้า 4: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 1: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 5: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 5: ราคา",
              "ตัวเลือกสินค้า 5: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 5: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 6: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 6: ราคา",
              "ตัวเลือกสินค้า 6: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 6: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 7: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 7: ราคา",
              "ตัวเลือกสินค้า 7: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 7: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 8: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 8: ราคา",
              "ตัวเลือกสินค้า 8: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 8: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 9: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 9: ราคา",
              "ตัวเลือกสินค้า 9: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 9: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 10: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 10: ราคา",
              "ตัวเลือกสินค้า 10: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 10: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 11: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 11: ราคา",
              "ตัวเลือกสินค้า 11: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 11: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 12: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 12: ราคา",
              "ตัวเลือกสินค้า 12: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 12: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 13: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 13: ราคา",
              "ตัวเลือกสินค้า 13: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 13: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 14: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 14: ราคา",
              "ตัวเลือกสินค้า 14: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 14: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)",
              "ตัวเลือกสินค้า 15: ชื่อตัวเลือกสินค้า",
              "ตัวเลือกสินค้า 15: ราคา",
              "ตัวเลือกสินค้า 15: สินค้าคงคลัง",
              "ตัวเลือกสินค้า 15: เลขอ้างอิงหน่วยสต็อกสินค้า(SKU Ref. No.)"
              ]
              next
            else ## if mode = "a"
              next
            end      
          end
          product = product_json[i]
          id = "1"
          title = product["title"]
          description = product["body_html"]
          price = product["variants"][0]["price"]
          inventory = product["variants"][0]["inventory_quantity"]
          weight = "0.1"
          prepare_time = ""
          sku = product["variants"][0]["sku"]
          v_sku=[]
          v_title=[]
          v_price =[]
          v_inventory =[]
          (0..14).each do |m|
            if product["variants"][m+1] 
                v_sku[m] = product["variants"][m+1]["sku"]
                v_title[m] = product["variants"][m+1]["sku"]
                v_price[m] = product["variants"][m+1]["title"]  
                v_inventory[m] = product["variants"][m+1]["inventory_quantity"]                
            else
                v_sku[m] =  ""
                v_title[m] =  ""
                v_price[m] = ""
                v_inventory[m] = ""
            end 
          end

          csv << [id,
              title,
              description,
              price,
              inventory,
              weight,
              prepare_time,
              sku,
              v_sku[0],
              v_title[0],
              v_price[0],
              v_inventory[0],
              v_sku[1],
              v_title[1],
              v_price[1],
              v_inventory[1],
              v_sku[2],
              v_title[2],
              v_price[2],
              v_inventory[2],
              v_sku[3],
              v_title[3],
              v_price[3],
              v_inventory[3],
              v_sku[4],
              v_title[4],
              v_price[4],
              v_inventory[4],
              v_sku[5],
              v_title[5],
              v_price[5],
              v_inventory[6],
              v_sku[6],
              v_title[6],
              v_price[6],
              v_inventory[6],
              v_sku[7],
              v_title[7],
              v_price[7],
              v_inventory[7],
              v_sku[8],
              v_title[8],
              v_price[8],
              v_inventory[8],
              v_sku[9],
              v_title[9],
              v_price[9],
              v_inventory[9],
              v_sku[10],
              v_title[10],
              v_price[10],
              v_inventory[10],
              v_sku[11],
              v_title[11],
              v_price[11],
              v_inventory[11],
              v_sku[12],
              v_title[12],
              v_price[12],
              v_inventory[12],
              v_sku[13],
              v_title[13],
              v_price[13],
              v_inventory[13],
              v_sku[14],
              v_title[14],
              v_price[14],
              v_inventory[14]
              ]
        end
    end    

    # send_file "file.csv"
  end ## end of get_shopee

def get_shopee_products_csv_all
  max_page = 0
  max_page = params[:maxpage].to_i if params[:maxpage].present?

  if max_page == 0 
    response = HTTParty.get("https://b7b232283836b5124bc13e40b1299be2:0f66356e3fd198115d2698a710db71f1@thaidiycupcake.myshopify.com/admin/products/count.json").body
    total_product =JSON.parse(response)["count"]
    total_decimal = (total_product/50.0).ceil
    max_page = total_decimal-1
    puts "maxpage is " + max_page.to_s
  end  

  (1..max_page).each do |page|
    if page == 1
      mode = "wb"
      get_shopee_products_csv(page.to_s,mode)
    else
      mode = "ab"
      get_shopee_products_csv(page.to_s,mode)
    end   
  end
  send_file "file.csv"
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
    puts ShopifyAPI::RecurringApplicationCharge.as_json
    if bill.present?
      @new_user = false
    else
      @new_user = true
      ##
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



