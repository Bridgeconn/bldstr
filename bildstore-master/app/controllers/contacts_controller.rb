class ContactsController < ApplicationController
	skip_before_action :authenticate_user!
	def new
		@contact = Contact.new
	end
	def create
		@contact = Contact.new(contact_params)
		if @contact.save
			redirect_to new_contact_path, notice: "Your request has been submited successfully, we will contact soon."
		else
			redirect_to new_contact_path, notice: "Something went wrong. Please try later"

		end
	end

	private

	def contact_params
		params.require(:contact).permit(:email, :full_name, :phone_number, :details, :order_number)
	end

end
