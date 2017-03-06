module ApplicationHelper
	def base_url
		Rails.configuration.public_url
	end
	
	def ajax_redirect_to(url)
	    head 302, x_ajax_redirect_url: url
	end

end
