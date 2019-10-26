class Address < ApplicationRecord

	#=======================================
	#=========== Association ===============
	#=======================================
	belongs_to :user
	validates_presence_of :first_name, :last_name, :country, :state, :postcode, :city, :address_line1, :phone_number

	def full_name
		"#{first_name} #{last_name}"
	end

end
