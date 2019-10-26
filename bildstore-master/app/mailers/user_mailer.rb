class UserMailer < ApplicationMailer
	include ApplicationHelper
	default from: "Bild Internationl India Store <registration@bildstore.in>"
	def send_account_info(user)
		@user = user
		mail(:to => [user.email]  , bcc: "registration@bildstore.in", :subject => " Thanks for Registering with BILD International India Store") do |format|
			format.html
		end
	end
end
