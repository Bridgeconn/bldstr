class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	before_action :configure_permitted_parameters, if: :devise_controller?
	helper_method :current_order, :available_categories, :country_name, :state_name
	before_action :authenticate_user!
	require "titleize.rb"
	def after_sign_up_path_for(resource)
		account_created_path # Or :prefix_to_your_route
	end


	def after_sign_in_path_for(resource)
		if(resource.is_admin?)
			session[:return_to] || admin_root_url
		else
			if request.referer && URI(request.referer).path == '/cart_items/checkout_without_login'
				choose_billing_address_cart_items_path
			else
				user_account_users_path
			end
		end
	end

	def authenticate_active_admin_user!
		authenticate_user!
		unless current_user.is_admin?
			flash[:alert] = "Unauthorized Access!"
			redirect_to root_path
		end
	end

	protected
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :password, :password_confirmation,:current_password,:email,:role, :address_attributes => [:first_name, :last_name, :company, :country, :post_code, :city, :state, :address_line1, :address_line2, :phone_number]) }
	end

	def current_order
		if !session[:order_id].nil?
			Order.find(session[:order_id])
		else
			if current_user.present?
				intiated_order = current_user.orders.where(status: 1).first
				if intiated_order
					intiated_order
				else
					Order.new
				end
			else
				Order.new
			end
		end
	end

	def available_categories
		Category.where("parent_id is null").active_category
	end

	def country_name(country_code)
		Country[country_code].name if country_code
	end

	def state_name(country_code, state_code)
		Country[country_code].states[state_code]["name"] if country_code && state_code
	end


end
