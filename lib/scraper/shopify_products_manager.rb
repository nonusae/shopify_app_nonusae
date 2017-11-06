module Scraper
  class ShopifyProductsManager
    require 'csv'
    require 'httparty'
    require 'open-uri'
    require 'openssl'
    require 'active_support/all'
    require 'scraper/image_uploader'

    def self.import(max, page, collection_id, product_type, vendor)
      image_error = 0
      fail_images_array = []
      query_string = ''
      query_string = "page=#{page}" if page
      query_string += "&product_type=#{product_type}" if product_type
      query_string += "&collection_id=#{collection_id}" if collection_id
      query_string += "&vendor=#{vendor}" if vendor
      puts ''
      puts '---------------------------------------------------------------------------------'
      puts ''
      puts 'Query string is :' + ' ' + query_string

      response = HTTParty.get(URI.encode("https://b7b232283836b5124bc13e40b1299be2:0f66356e3fd198115d2698a710db71f1@thaidiycupcake.myshopify.com/admin/products.json?#{query_string}&order=created_at+DESC")).body
      json_res = JSON.parse(response)

      product_json = json_res['products'] # this is an array of product

      total = product_json.count
      maximum = total if max == '0'
      max = max.to_i
      i = 0
      while i <= max - 1
        # (0..(2)).each do | i |
        product = product_json[i]
        i += 1
        # puts "i = #{i}"
        next if product.nil?
        first_variant = product['variants'][0]

        if product['variants'].count > 1
          puts 'Product with multiple variants. Skip...'
          max += 1
          next
        end

        if Product.find_by_title(product['title'])
          puts 'Duplicated'
          max += 1
          next
        end
        title = product['title']
        puts ''
        puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
        puts ''
        puts 'Product title is ' + title
        model = product['product_type']
        full_description = product['body_html']
        short_description = get_short_description(full_description)
        puts 'SHORT DES is ' + short_description
        # puts first_variant["sku"] + "  AAAAAAAAAA"
        seller_sku = if first_variant['sku'] == 'null'
                       'diycake' + rand(10_000).to_s
                     else
                       first_variant['sku']
                     end
        quantity = first_variant['inventory_quantity']
        price = first_variant['price']
        package_content = product['title']
        if first_variant['grams'] == '0' || first_variant['grams'] == 0
          package_weight = '0.15'
        else
          package_weight = (first_variant['grams'].to_i * 0.001).to_s
        end
        package_width = '10'
        package_height = '10'
        package_length =  '10'
        name_en = product['handle'].tr('-', ' ')
        # puts name_en
        name_en[0] = name_en[0].capitalize! unless name_en[0] =~ /^[0-9]+$/

        product_ins = Product.new
        product_ins.title = title
        product_ins.model = model
        product_ins.description = full_description
        product_ins.short_description = short_description
        product_ins.seller_sku = seller_sku
        product_ins.quantity = quantity
        product_ins.price = price
        product_ins.package_content = package_content
        product_ins.package_weight = package_weight
        product_ins.name_en = name_en

        product_id = product_ins.id if product_ins.save

        (0..8).each do |n|
          if product['images'][n]
            img_src = product['images'][n]['src']
            img_width = product['images'][n]['width']
            img_height = product['images'][n]['height']
            image = Image.new
            image.product_id = product_id
            image.img_url = img_src
            image.width = img_width
            image.height = img_height

            if image.save
              puts ''
              puts '----------------------------------------------------'
              puts 'New image created'
              puts 'Beginning migrate image id = ' + image.id.to_s
              begin
                sleep(1)
                result = Scraper::ImageUploader.lazada_migrate(image.id)
                puts 'Success migrate !!' if result[0] == 'Success'
                if result[0] == 'Fail'
                  image_error += 1
                  img_fail_url = result[1]
                  fail_images_array << img_fail_url
                end
              rescue
                puts 'Error in image migration'
              end
            end
          else
            next
          end
          puts '----------------------------------------------------'
        end # End of 0..8

        next unless product_ins.images.count == 0
        puts ''
        puts 'Product with 0 images destroying...'
        puts ''
        product_ins.destroy
        max += 1

      end
      [image_error, fail_images_array]
    end

    def self.upload_to_lazada(product_id, category, multiplier)
      final_error = nil

      product = Product.find_by_id(product_id)
      title = product.title

      api_key = 'ig1H7tDYaPJDho5ZQkEA1DiD3AS37dK-IVXFCsLseGCMwLqIFOPMKUDi'
      user_id = 'nonusae@gmail.com'
      user_id = ERB::Util.url_encode(user_id)
      action = 'CreateProduct'
      output_format = 'json'
      version = '1.0'
      version = ERB::Util.url_encode(version)
      time_stamp = DateTime.parse(Time.now.to_s).iso8601(0)
      time_stamp = ERB::Util.url_encode(time_stamp).gsub('.', '%3A')

      query_string = "Action=#{action}&Format=#{output_format}&Timestamp=#{time_stamp}&UserID=#{user_id}&Version=#{version}"

      singnature = OpenSSL::HMAC.hexdigest('sha256', api_key, query_string)

      query_string = query_string + '&Signature=' + singnature

      request = 'https://api.sellercenter.lazada.co.th?' + query_string
      data = {}
      data.compare_by_identity
      image_hash = {}.compare_by_identity
      i = 0
      product.images.each do |image|
        break if i == 7
        puts image.lazada_url
        image_hash[String.new('Image')] = image.lazada_url
        i += 1
      end

      ## price manipulator
      input_price = product.price.to_i
      if input_price > 100
        modified_price = (input_price * multiplier.to_f).to_i
        last_digit = modified_price.to_s[-1].to_i
        if last_digit > 0 && last_digit < 5
          last_digit = 5
          new_modified_price = modified_price.to_s[0..-2] + last_digit.to_s
        elsif last_digit > 5 && last_digit < 9
          last_digit = 9
          new_modified_price = modified_price.to_s[0..-2] + last_digit.to_s
        else
          new_modified_price = modified_price.to_s
        end

        new_modified_price = new_modified_price.to_i
      else
        new_modified_price = input_price
        end
      ##
      data = {
        Product: {
          PrimaryCategory: category.to_s,
          SPUId: '',
          Attributes: {
            name: product.title,
            short_description: '<![CDATA[' + product.short_description,
            description: product.description,
            name_en: product.name_en,
            warranty_type: 'Warranty by Seller',
            warranty: '3 Months',
            brand: 'Thai DIY Cupcake',
            model: product.model
          }, # End of Attribues
          Skus: {
            Sku: {
              SellerSku: product.seller_sku,
              color_family: 'Not Specified',
              size: '41',
              quantity: product.quantity,
              price: (new_modified_price * 2.0).to_s,
              special_price: new_modified_price.to_s,
              special_from_date: DateTime.yesterday.strftime('%Y-%m-%d').to_s,
              special_to_date: (DateTime.yesterday + 5.year).strftime('%Y-%m-%d').to_s,
              package_length: '10',
              package_height: '10',
              package_weight: product.package_weight,
              package_width: '10',
              package_content: product.package_content,
              Images: image_hash # End of Images
            } # End of Sku
          } # End of Skus
        } # End of Product
      }

      res = HTTParty.post(request, headers: {
                            'Content-Type' => 'text/xml',
                            'charset' => 'utf-8',
                            'Accept' => 'application/json'
                          },
                                   body: data.to_xml.gsub('hash', 'Request').gsub('package-length', 'package_length').gsub('package-height', 'package_height').gsub('package-weight', 'package_weight').gsub('package-width', 'package_width').gsub('package-content', 'package_content').gsub('name-en', 'name_en').gsub('warranty-type', 'warranty_type').gsub('short-description', 'short_description').gsub('color-family', 'color_family').gsub('barcode-ean', 'barcode_ean').gsub('special-from-date', 'special_from_date').gsub('special-to-date', 'special_to_date').gsub('special-price', 'special_price'))

      json_res = JSON.parse(res.body)

      if json_res['SuccessResponse']
        puts 'Successfully upload product'
      else
        puts 'Upload Image Fail !!. With product id = ' + product_id.to_s
      end

      puts res

      if res['ErrorResponse'].present?
        sku = res['ErrorResponse']['Body']['Errors'][0]['SellerSku']
        field = res['ErrorResponse']['Body']['Errors'][0]['Field']
        message = res['ErrorResponse']['Body']['Errors'][0]['Message']
        error_hash = { error:
                              {
                                sku: sku,
                                field: field,
                                message: message
                              } }
        final_error = error_hash
      end

      final_error
    end

    def self.get_short_description(full_description)
      first_filter = full_description.split("\n").join('')[/<ul>(.*)<\/ul>/, 1]
      puts 'FULL is ' + full_description.split("\n").join('')
      if first_filter.present?
        short_description = '<ul>' + first_filter + '</ul>'
        puts '1234123'
      else
        short_description = '<ul><li>รับประกันสินค้า</li><li>คุณภาพดี</li><li>สินค้าพร้อมส่ง</li></ul>'
      end

      short_description
    end
  end
end
