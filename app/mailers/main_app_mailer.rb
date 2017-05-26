class MainAppMailer < ApplicationMailer

	default from: "solutionsify@gmail.com"

	def sample_email(shop_domain,email)
		@shop_domain = shop_domain
		mail(to: email, subject: "Thank you for install our app")
	end

end
