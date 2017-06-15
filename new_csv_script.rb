require 'csv'
require 'httparty'

 def get_shopee_products_csv(page,mode,product_type,collection_id,vendor,category_id,days_to_ship)
    query_string = ""
    query_string = "page=#{page}" if page
    query_string += "&product_type=#{product_type}" if product_type
    query_string += "&collection_id=#{collection_id}" if collection_id
    query_string += "&vendor=#{vendor}" if vendor
    puts "Q"  + " " + query_string
    response = HTTParty.get(URI.encode("https://b7b232283836b5124bc13e40b1299be2:0f66356e3fd198115d2698a710db71f1@thaidiycupcake.myshopify.com/admin/products.json?#{query_string}&order=created_at+DESC")).body
    json_res = JSON.parse(response)
    product_json = json_res["products"] # this is an array of product


    total = product_json.count
    CSV.open("file.csv", mode) do |csv|
        (-1..(total-1)).each do | i |
          if i == -1
            if mode == "wb"
              csv << ["ps_category_list_id",
              "ps_product_name",
              "ps_product_description",
              "ps_price",
              "ps_stock",
              "ps_product_weight",
              "ps_days_to_ship",
              "ps_sku_ref_no_parent",
              "ps_mass_upload_variation_help",
              "ps_variation 1 ps_variation_sku",
              "ps_variation 1 ps_variation_name",
              "ps_variation 1 ps_variation_price",
              "ps_variation 1 ps_variation_stock",
              "ps_variation 2 ps_variation_sku",
              "ps_variation 2 ps_variation_name",
              "ps_variation 2 ps_variation_price",
              "ps_variation 2 ps_variation_stock",
              "ps_variation 3 ps_variation_sku",
              "ps_variation 3 ps_variation_name",
              "ps_variation 3 ps_variation_price",
              "ps_variation 3 ps_variation_stock", 
              "ps_variation 4 ps_variation_sku",
              "ps_variation 4 ps_variation_name",
              "ps_variation 4 ps_variation_price",
              "ps_variation 4 ps_variation_stock",             
              "ps_variation 5 ps_variation_sku",
              "ps_variation 5 ps_variation_name",
              "ps_variation 5 ps_variation_price",
              "ps_variation 5 ps_variation_stock", 
              "ps_variation 6 ps_variation_sku",
              "ps_variation 6 ps_variation_name",
              "ps_variation 6 ps_variation_price",
              "ps_variation 6 ps_variation_stock",
              "ps_variation 7 ps_variation_sku",
              "ps_variation 7 ps_variation_name",
              "ps_variation 7 ps_variation_price",
              "ps_variation 7 ps_variation_stock",
              "ps_variation 8 ps_variation_sku",
              "ps_variation 8 ps_variation_name",
              "ps_variation 8 ps_variation_price",
              "ps_variation 8 ps_variation_stock", 
              "ps_variation 9 ps_variation_sku",
              "ps_variation 9 ps_variation_name",
              "ps_variation 9 ps_variation_price",
              "ps_variation 9 ps_variation_stock",             
              "ps_variation 10 ps_variation_sku",
              "ps_variation 10 ps_variation_name",
              "ps_variation 10 ps_variation_price",
              "ps_variation 10 ps_variation_stock", 
              "ps_variation 11 ps_variation_sku",
              "ps_variation 11 ps_variation_name",
              "ps_variation 11 ps_variation_price",
              "ps_variation 11 ps_variation_stock",
              "ps_variation 12 ps_variation_sku",
              "ps_variation 12 ps_variation_name",
              "ps_variation 12 ps_variation_price",
              "ps_variation 12 ps_variation_stock",
              "ps_variation 13 ps_variation_sku",
              "ps_variation 13 ps_variation_name",
              "ps_variation 13 ps_variation_price",
              "ps_variation 13 ps_variation_stock", 
              "ps_variation 14 ps_variation_sku",
              "ps_variation 14 ps_variation_name",
              "ps_variation 14 ps_variation_price",
              "ps_variation 14 ps_variation_stock",             
              "ps_variation 15 ps_variation_sku",
              "ps_variation 15 ps_variation_name",
              "ps_variation 15 ps_variation_price",
              "ps_variation 15 ps_variation_stock", 
              "ps_img_1",
              "ps_img_2",
              "ps_img_3",
              "ps_img_4",
              "ps_img_5",
              "ps_img_6",
              "ps_img_7",
              "ps_img_8",
              "ps_img_9"
              ]
              next
            else ## if mode = "a"
              next
            end      
          end
          product = product_json[i]
          id = category_id.to_s
          title = product["title"]
          description = product["title"]
          price = product["variants"][0]["price"]
          product["variants"][0]["inventory_quantity"] != 1 ? inventory = product["variants"][0]["inventory_quantity"] : inventory = 99
          weight = product["variants"][0]["weight"]
          days_to_ship ? prepare_time = days_to_ship.to_s : prepare_time = "15"
          sku = product["variants"][0]["sku"]
          v_sku=[]
          v_title=[]
          v_price =[]
          v_inventory =[]
          img = []
          (0..14).each do |m|
            if product["variants"][m+1] 
                v_sku[m] = product["variants"][m+1]["sku"]
                v_title[m] = product["variants"][m+1]["title"]
                v_price[m] = product["variants"][m+1]["price"]  
                product["variants"][m+1]["inventory_quantity"] != 1 ? v_inventory[m] = product["variants"][m+1]["inventory_quantity"] : v_inventory[m] = "99"           
            else
                v_sku[m] =  ""
                v_title[m] =  ""
                v_price[m] = ""
                v_inventory[m] = ""
            end 
          end

          (0..8).each do |n|
            if product["images"][n]
              img[n] = product["images"][n]["src"]
            else
              img[n] = ""
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
              "",
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
              v_inventory[5],
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
              v_inventory[14],
              img[0],
              img[1],
              img[2],
              img[3],
              img[4],
              img[5],
              img[6],
              img[7],
              img[8]
              ]
        end
    end    

    # send_file "file.csv"
  end ## end of get_shopee

def get_shopee_products_csv_all(maxpage,product_type,collection_id,vendor,category_id,days_to_ship)
  max_page = 0
  max_page = maxpage.to_i

  if max_page == 0
    query_string = ""
    query_string += "product_type=#{product_type}" if product_type
    query_string += "&collection_id=#{collection_id}" if collection_id
    query_string += "&vendor=#{vendor}" if vendor
    puts "Q" + query_string
    response = HTTParty.get(URI.encode("https://b7b232283836b5124bc13e40b1299be2:0f66356e3fd198115d2698a710db71f1@thaidiycupcake.myshopify.com/admin/products/count.json?#{query_string}&order=created_at+DESC")).body
    total_product =JSON.parse(response)["count"]
    total_decimal = (total_product/50.0).ceil
    max_page = total_decimal
    puts "maxpage is " + max_page.to_s
  end  

  (1..max_page).each do |page|
    puts "Processing page: " + page.to_s + "..."
    if page == 1
      mode = "wb"
      get_shopee_products_csv(page.to_s,mode,product_type,collection_id,vendor,category_id,days_to_ship)
    else
      mode = "ab"
      get_shopee_products_csv(page.to_s,mode,product_type,collection_id,vendor,category_id,days_to_ship)
    end   
  end
  # send_file "file.csv"
end


ARGV[0] ?  page = ARGV[0] : page = 0
# puts CGI.escape(ARGV[1])
( ARGV[1] and ARGV[1] != "-") ? product_type = ARGV[1] : product_type = nil
( ARGV[2] and ARGV[2] != "-") ? collection_id = ARGV[2] : collection_id = nil
( ARGV[3] and ARGV[3] != "-") ? vendor = ARGV[3] : vendor = nil
( ARGV[4] and ARGV[4] != "-") ? category_id = ARGV[4] : category_id = "0"
( ARGV[5] and ARGV[5] != "-") ? days_to_ship = ARGV[5] : days_to_ship = 15

puts page
puts product_type

get_shopee_products_csv_all(page,product_type,collection_id,vendor,category_id,days_to_ship)



