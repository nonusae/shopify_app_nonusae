class MainAppMailer < ApplicationMailer

	default from: "solutionsify@gmail.com"

	def sample_email(shop_domain,email,shop_name)
		@shop_domain = shop_domain
		@shop_name = shop_name
		mail(to: email, subject: "Thank you for install our app")
	end

end
