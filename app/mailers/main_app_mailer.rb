class MainAppMailer < ApplicationMailer

	default from: "nonusae@gmail.com"

	def sample_email
		mail(to: "nonusae@gmail.com", subject: "Sample Email")
	end

end
