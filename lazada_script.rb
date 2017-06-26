require 'csv'
require 'httparty'
require 'open-uri'
require 'openssl'
require "active_support/all"


def genHash(secret, data)
  OpenSSL::HMAC.hexdigest('sha256', secret, data)
end



api_key = "ig1H7tDYaPJDho5ZQkEA1DiD3AS37dK-IVXFCsLseGCMwLqIFOPMKUDi"
user_id = "nonusae@gmail.com"
user_id = ERB::Util.url_encode(user_id)
action = "CreateProduct"
output_format = "json"
version = "1.0"
version = ERB::Util.url_encode(version)
time_stamp = DateTime.parse(Time.now.to_s).iso8601(0)
time_stamp = ERB::Util.url_encode(time_stamp).gsub(".","%3A")


query_string = "Action=#{action}&Format=#{output_format}&Timestamp=#{time_stamp}&UserID=#{user_id}&Version=#{version}"

singnature = genHash(api_key,query_string)

query_string = query_string + "&Signature=" + singnature


request = "https://api.sellercenter.lazada.co.th?" + query_string

# res = HTTParty.get(request)

data = {
        :Product => {
            :PrimaryCategory => "4709",
            :SPUId => "",
            :Attributes => {
                :name => "api create product test sample",
                :short_description => '<![CDATA[<ul><li>AA</li></ul>]]>',
                :name_en => "Mold",
                :warranty_type => "No Warranty",
                :brand => "Remark",
                :model => "asdf",
                :kid_years => "(6-10yrs)"
            },# End of Attribues
            :Skus => {
                :Sku => {
                    :SellerSku => "api-create-test-9",
                    :color_family => "Green",
                    :size => "41",
                    :quantity => "2",
                    :price => "520.88",
                    :package_length => "11",
                    :package_height => "22",
                    :package_weight => "33",
                    :package_width => "44",
                    :package_content => "this is what's in the box",
                    :Images => {
                        :Image => "http://srv-live.lazada.co.th/cms/201602/20160816-kitchen-2.png",
                        :Image => "http://srv-live.lazada.co.th/cms/201602/20160816-kitchen-2.png"
                    } #End of Images
                } #End of Sku
            } # End of Skus
        } #End of Product
    }

res = HTTParty.post(request,{
              :headers => {
                            'Content-Type' => 'text/xml', 
                            "charset" => "utf-8",
                            'Accept' => 'application/json'               
                            },
               :body => data.to_xml.gsub("hash","Request").gsub("package-length","package_length").gsub("package-height","package_height").gsub("package-weight","package_weight").gsub("package-width","package_width").gsub("package-content","package_content").gsub("name-en","name_en").gsub("warranty-type","warranty_type").gsub("short-description","short_description").gsub("color-family","color_family")
        } 
    ) 




puts res




