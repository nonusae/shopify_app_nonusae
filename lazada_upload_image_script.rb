require 'csv'
require 'httparty'
require 'open-uri'
require 'openssl'
require "active_support/all"
require "base64"


def genHash(secret, data)
  OpenSSL::HMAC.hexdigest('sha256', secret, data)
end



api_key = "ig1H7tDYaPJDho5ZQkEA1DiD3AS37dK-IVXFCsLseGCMwLqIFOPMKUDi"
user_id = "nonusae@gmail.com"
user_id = ERB::Util.url_encode(user_id)
action = "MigrateImage"
output_format = "json"
version = "1.0"
version = ERB::Util.url_encode(version)
time_stamp = DateTime.parse(Time.now.to_s).iso8601(0)
time_stamp = ERB::Util.url_encode(time_stamp).gsub(".","%3A")


query_string = "Action=#{action}&Format=#{output_format}&Timestamp=#{time_stamp}&UserID=#{user_id}&Version=#{version}"

singnature = genHash(api_key,query_string)

query_string = query_string + "&Signature=" + singnature


request = "https://api.sellercenter.lazada.co.th?" + query_string
# request = "https://requestb.in/q7vzxiq7?" + query_string

# res = HTTParty.get(request)

data = { :Image =>
             { :Url => "https://www.calliaweb.co.uk/wp-content/uploads/2015/10/600x600.jpg" } 
        }



res = HTTParty.post(request,{
              :headers => {
                            "Content-Type" => "text/xml",
                            'Accept' => 'application/json'               
                            },
               :body => data.to_xml.gsub("hash","Request")
        } 
    ) 




puts JSON.parse(res.body)["SuccessResponse"]["Body"]["Image"]["Url"]



