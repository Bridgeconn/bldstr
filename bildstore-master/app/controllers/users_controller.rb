class UsersController < ApplicationController

	def user_account
	end

	def address_book
		@addresses = current_user.addresses
	end

	def orders_completed
		@orders = current_user.orders.where(status: 3).order('id DESC').page(params[:page])
	end


	def order_status
		@orders = current_user.orders.recent_cancelled_order
	end

	def order_details
		@order = current_user.orders.find(params[:id])
	end

	def recent_visit_items
		@products = current_user.recent_product_visits
	end

	def user_account
		@user = current_user
	end


	def update_password
		@user = User.find(current_user.id)
		if user_params[:password].blank?
			user_params.delete(:password)
			user_params.delete(:password_confirmation) if user_params[:password_confirmation].blank?
			if @user.update_without_password(user_params)
				redirect_to user_account_users_path, notice:"Your account details have been updated."
			else
				render "user_account"
			end
		else
			if @user.valid_password?(params[:user][:current_password])
				if @user.update(user_params)
					# Sign in the user by passing validation in case their password changed
					bypass_sign_in(@user)
					redirect_to user_account_users_path, notice:"Your account details have been updated."
				else
					render "user_account"
				end
			else
				flash[:error] = "Please type in your current password."
				redirect_to user_account_users_path
			end
		end
	end

	private

	def user_params
		# NOTE: Using `strong_parameters` gem
		params.require(:user).permit(:first_name, :last_name, :phone_number, :password, :password_confirmation)
	end


end
