class ContactMailer < ApplicationMailer
	default from: "Bild International India Store <contacts@bildstore.in>"

	def send_request(contact)
		@contact = contact
		mail(:to => ENV["contact_email"] , :subject => "user request") do |format|
			format.html
		end
	end

end
