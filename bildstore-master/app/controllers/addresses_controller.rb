class AddressesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:change_country_text, :list_states]

	def new
		@address = current_user.addresses.new
	end

	def create
		@address = current_user.addresses.new(address_params)
		if @address.save
			redirect_to address_book_users_path
		else
			render :new
		end
	end

	def edit
		@address = current_user.addresses.find(params[:id])
	end

	def update
		@address = current_user.addresses.find(params[:id])
		@address.update_attributes(address_params)
		redirect_to address_book_users_path
	end

	def destroy
		@address = current_user.addresses.find(params[:id])
		@address.destroy
		redirect_to address_book_users_path
	end

	def list_states
		if params[:country_2_code].present?
			render :json => Country["#{params[:country_2_code]}"].states
		else
			render :text => "Please select a country to continue..."
		end
	end

	def change_country_text
		if params[:country_2_code].present?
			render json: {country_text: Country[params[:country_2_code]].name, states: Country[params[:country_2_code]].states }
		else
			render :text => "Please select country"
		end
	end

	private

	def address_params
		params.require(:address).permit(:first_name, :last_name, :country, :state, :city, :postcode, :address_line1, :address_line2, :phone_number)
	end

end
