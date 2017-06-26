class ApplicationController < ActionController::Base
  include ShopifyApp::LoginProtection
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def base_url
    Rails.configuration.public_url
  end

  def get_products_csv
    api_key = ""
    password = ""
    url = "https://b7b232283836b5124bc13e40b1299be2:0f66356e3fd198115d2698a710db71f1@thaidiycupcake.myshopify.com/admin/products.json"
    response = HTTParty.get(url).body.to_s
    j_response = JSON.parse(response)["products"]


    File.new("~/Desktop/file_test.json", "w") unless File.open("~/Desktop/file_test.json","w")
    File.open("~/Desktop/file_test.json","w") do |f|
      f.write(j_response)
    end     

    # csv_string = CSV.generate do |csv|
    CSV.open("/Users/mychicha/Desktop/filesss.csv", "wb") do |csv|
      j_response["products"].each do |a|
        csv << a
      end
    end

  end

end