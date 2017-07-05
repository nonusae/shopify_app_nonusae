namespace :product_tasks do
  desc "Importing product and upload related images to Lazada"
  task :import_products, [:no_of_products,:page,:collection_id,:product_type,:vendor] => [:environment] do |t, args|

    page = 0
    collection_id = nil
    product_type =nil
    vendor = nil

    page =  args[:page] if args[:page].present?
    collection_id =  args[:collection_id] if args[:collection_id].present?
    product_type =  args[:product_type] if args[:product_type].present?
    vendor =  args[:vendor] if args[:vendor].present?
    no_of_products = args[:no_of_products]
    if no_of_products.nil?
        no_of_products = 0
    end
    puts ""
    puts '####################################################'    
    puts "Start importing products..."
    puts "no_of_products = " + no_of_products.to_s 
    puts "page = " + page.to_s 
    puts "collection_id = " + collection_id.to_s 
    puts "product_type = " + product_type.to_s 
    puts "vendor = " + vendor.to_s 
    puts '####################################################' 

    Scraper::ShopifyProductsManager.import(no_of_products,page,collection_id,product_type,vendor)

    puts "---------------------------------------------------------------------------------"

  end

  desc "Uploading to products to lazada account"
  task :upload_to_lazada,[:category] => [:environment] do |t, args|
    category = nil
    category =  args[:category] if args[:category].present?
    if category.present?
      Product.all.each do |p|
          puts "uploading product id " + p.id.to_s
          sleep(1)
          Scraper::ShopifyProductsManager.upload_to_lazada(p.id,category)
      end
    else
      puts "Please enter lazada category"
    end
  end

  desc "Clear all product database"
  task :clear => [:environment] do
    puts "Starting clearing database..."
      Image.destroy_all
      Product.destroy_all
    puts "Finish!!"  
  end


end
