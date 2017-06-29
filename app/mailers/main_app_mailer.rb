class MainAppMailer < ApplicationMailer

	default :from => "Solutionsify <no-reply@email.com>"

	def sample_email(shop_domain,email,shop_name)
		@shop_domain = shop_domain
		@shop_name = shop_name
		mail(to: email,cc: "kong707@gmail.com" , subject: "Hello from Product Tags Translator App")
	end

end
