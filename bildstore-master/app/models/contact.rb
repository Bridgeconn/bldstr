class Contact < ApplicationRecord
	validates :email, presence: true, :format => { :with => %r{.+@.+\..+} }
	validates :details, presence: true
	after_save :send_request

	def send_request
		ContactMailer.send_request(self).deliver
	end



end
