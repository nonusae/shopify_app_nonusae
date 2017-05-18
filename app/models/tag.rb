class Tag < ActiveRecord::Base
	belongs_to :shopify_shop

	def is_group_tag?
		puts "come in group tag function"
		title = self.title
		title_div = title.split("_")
		if title_div.length == 2
			puts "gruop_tag detect"
			return true
		else
			return false
		end
	end

	def assign_group_tag_value
		if self.is_group_tag 
			puts "in functions"
			ss = self.title.split("_")
			self.update_attribute(:group_tag_cat,ss[0])
			self.update_attribute(:group_tag_sub,ss[1])
		end
	end

	def update_is_group_tag_boolean
   		puts "come to update_is_group_tag_boolean def"
   		title = self.title   
		title_div = title.split("_")
		if title_div.length == 2
			puts "gruop_tag detect updating"
			self.update_attribute(:is_group_tag,true)
		else
			self.update_attribute(:is_group_tag,false)
		end   		
	end



end
