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
  task :upload_to_lazada,[:category,:multipier] => [:environment] do |t, args|
    multipier = 1.13
    category = nil
    multipier = args[:multipier] if args[:multipier].present?
    category =  args[:category] if args[:category].present?
    total = Product.count
    success_no = 0
    fail_no = 0
    error_hash = []
    if category.present?
      Product.all.each do |p|
          puts "uploading product id " + p.id.to_s
          sleep(1)
          error = Scraper::ShopifyProductsManager.upload_to_lazada(p.id,category,multipier)
          unless error.nil?
            error_hash << error
            fail_no += 1
          else
            success_no += 1
          end
      end
    else
      puts "Please enter lazada category"
    end
    puts ""
    puts "Finish upload product..."
    puts "Summary of uploading"
    puts "Total: #{total.to_s}"
    puts "Sucess: #{success_no.to_s}"
    puts "Fail: #{fail_no}"

    m = 0
    if error_hash.count > 0
      error_hash.each do |error|
        m += 1
        sku = error[:error][:sku]
        field = error[:error][:field]
        message = error[:error][:message]
        puts "--------------------------------------------"
        puts "Error no.#{m}"
        puts "Sku: #{sku}"
        puts "Field: #{field}"
        puts "Message: #{message}"
        puts "--------------------------------------------"
        puts ""
      end
    end

    puts "-------------- Finish Upload ------------------" 

  end

  desc "Clear all product database"
  task :clear => [:environment] do
    puts "Starting clearing database..."
      Image.destroy_all
      Product.destroy_all
    puts "Finish!!"  
  end


end
