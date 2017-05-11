class TagsController < ApplicationController


    def update_multiple
      shop_domain = params[:shop]
      @shop = ShopifyShop.find_by_shop_domain(shop_domain)
      @tags = Tag.find(params[:tag_ids])
      @tags.each do |tag|
       unless tag.is_group_tag  
        id = tag.id.to_s
        puts params[:tags][id]["thai_title"]
        tag.update_attribute(:thai_title,params[:tags][id]["thai_title"])
       else
        id = tag.id.to_s
        puts params[:tags][id]["group_tag_thai_cat"]
        puts params[:tags][id]["group_tag_thai_sub"]
        unless params[:tags][id]["group_tag_thai_cat"].split("_")[0] == "GARP"
            tag.update_attribute(:group_tag_thai_cat,params[:tags][id]["group_tag_thai_cat"])
        else
            cat = params[:tags][id]["group_tag_thai_cat"].split("_")[1]
            thai_cat = @shop.tags.where(group_tag_cat: cat).order("title ASC").first.group_tag_thai_cat
            tag.update_attribute(:group_tag_thai_cat,thai_cat)
        end

        tag.update_attribute(:group_tag_thai_sub,params[:tags][id]["group_tag_thai_sub"])
       end
      end
      redirect_to root_path(:shop => shop_domain)
    end

    def get_all_translated_tag
        @tag = Tag.all
        respond_to do |format|
            format.json { render :json => @tag }
        end 
    end

    def get_translated_tag
        @shop = ShopifyShop.find_by_shop_domain(params[:shop_domain])
        t = params[:tags].split(",") # use this instead of where for correct order
        @tag= []
        puts "t is: #{t}"
        t.each do |tt|
            puts "tt is #{tt}"
            tag = @shop.tags.find_by_title(tt)
            tag = "" unless tag.present?
            @tag << tag
        end
        puts params[:tags].split(",")
        # @tag.each do |a_tag|
        #   puts a_tag.id
        #   puts a_tag.thai_title
        # end
        respond_to do |format|
            format.json { render :json => @tag }
        end         
    end

    def get_translated_group_tag2
     ## input is params[:data]
     ## format will be a= [ [group_cat1,group_cat2],[group_sub_by_tag1,group_sub_by_tag2] ]
     ## for m
        ## a[0][m] for group_cat translated date replace group-tag-m
        ## i
                ## a[1][i] fot group_sub tranlated data replace group-tag-sub-m_i
     ## group cat will be replace by js with m increment aand groupsub will be replace by m_i
     @shop = ShopifyShop.find_by_shop_domain(params[:shop_domain])
     cat_array = params[:tags].split("*:*")[0].split(",")
     sub_array = params[:tags].split("*:*")[1].split(",")
     @tag = [[],[]]

     cat_array.each do |cat|
        puts "cat is #{cat}"
        cat = @shop.tags.where(group_tag_cat: cat.to_s).first
        cat = "" unless cat.present?
        @tag[0] << cat
     end

     sub_array.each do |subs|
        puts "sub tag is #{subs}"
        subs =  @shop.tags.find_by_title(subs)
        @tag[1] << subs
     end

    respond_to do |format|
        format.json { render :json => @tag }
    end      


    end

    def get_translated_group_tag
         a= params[:tags].split("*:*")
         b= a
         total = []
         b.each do |bb|
            total << bb.split(",")
         end

         result = []
            m = 0
            total.each do  |t|
                i = 0
                t.each do |tt|
                    if i == 0
                        result << []
                        tag = @shop.tags.where(group_tag_cat: tt.to_s).first 
                        result[m] << tag
                        result[m] << []
                    else
                        tag = @shop.tags.find_by_title(tt)
                        result[m][1] << tag
                    end
                    i += 1
                end
                m +=1
            end

        @tag = result
        puts "API RESULT"
        puts @tag
        respond_to do |format|
            format.json { render :json => @tag }
        end

    end


end