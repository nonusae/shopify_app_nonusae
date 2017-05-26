class MainAppMailer < ApplicationMailer

	default from: "solutionsify@gmail.com"

	def sample_email(shop_domain)
		@shop_domain = shop_domain
		mail(to: "nonusae@gmail.com", subject: "Thank you for install our app")
	end

end
