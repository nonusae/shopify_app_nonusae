namespace :product_tasks do
  desc "TODO"
  task :import_products, [:no_of_products] => [:environment] do |t, args|
    no_of_products = args[:no_of_products]
    if no_of_products.nil?
        no_of_products = 0
    end
    puts "Start importing"
    Scraper::ShopifyProductsManager.import(no_of_products)

  end

  desc "TODO"
  task upload_to_lazada: :environment do
    Product.all.each do |p|
        puts "uploading product id " + p.id.to_s
        sleep(1)
        Scraper::ShopifyProductsManager.upload_to_lazada(p.id)
    end
  end

end
