class MainAppMailer < ApplicationMailer

	default from: "Solutionsify"

	def sample_email(shop_domain,email,shop_name)
		@shop_domain = shop_domain
		@shop_name = shop_name
		mail(to: email, subject: "Hello from Product Tags Translator App")
	end

end
