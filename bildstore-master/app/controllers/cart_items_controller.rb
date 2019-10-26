class CartItemsController < ApplicationController
	helper_method :resource_name, :resource, :devise_mapping
	before_action :check_guest_user_access, only: [:guest_billing_details, :guest_shipping_address]
	# skip_before_action :authenticate_user!
	before_action :check_order
	before_action :check_cart_items, only: [:choose_billing_address, :choose_shipping_address, :order_confirmation, :guest_confirm_order]
	def add_to_cart
		@order = current_order
		@cart_item = @order.cart_items.where('product_id = ?', params[:product_id]).first
		if params[:quantity]
			quantity = params[:quantity]
		else
			quantity = 1
		end
		if params[:quantity] && params[:quantity].to_i >= 101
			redirect_to bulk_info_cart_items_path
			return
		end

		if @cart_item
			@cart_item.quantity = @cart_item.quantity + quantity.to_i
			@cart_item.save
		else
			@cart_item = @order.cart_items.new(product_id: params[:product_id], quantity: quantity.to_i)
		end
		@order.user_id = current_user.id if current_user
		@order.save
		session[:order_id] = @order.id
		redirect_to cart_details_cart_items_path
	end

	def cart_details
		@cart_items = current_order.cart_items
	end

	def update
		@order = current_order
		@cart_item = @order.cart_items.find(params[:id])
		if !cart_item_params[:quantity].blank? && cart_item_params[:quantity].to_s.to_i >= 101
			redirect_to bulk_info_cart_items_path
			return
		end
		if !cart_item_params[:quantity].blank? && cart_item_params[:quantity].to_s.to_i != 0
			@cart_item.update_attributes(cart_item_params)
			@order.save
		else
			@cart_item.destroy
		end
		@cart_items = @order.cart_items
		redirect_to cart_details_cart_items_path,	 notice: "The contents of your shopping cart have been updated."
	end

	def destroy
		@order = current_order
		@cart_item = @order.cart_items.find(params[:id])
		@cart_item.destroy
		@cart_items = @order.cart_items
		redirect_to cart_details_cart_items_path
	end

	def checkout
		# @delivery_address = (current_user && current_user.present?) ? ((current_user.delivery_address.present?) ? current_user.delivery_address : current_user.build_delivery_address) : Address.new
		if params[:checkout_type] == "register"
			redirect_to new_user_registration_path
		else
			redirect_to guest_billing_details_cart_items_path
		end
		@cart_items = current_order.cart_items
	end

	def checkout_without_login

	end

	def guest_billing_details
		@order = current_order
		@country = @order.billing_country.present? ? Country[@order.billing_country] : Country["IN"];
	end

	def guest_shipping_address
		@order = current_order
		@country = @order.billing_country.present? ? Country[@order.billing_country] : Country["IN"];
	end


	def proceed_checkout

	end

	def choose_billing_address
		if !current_user.addresses.present?
			redirect_to address_book_users_path
		else
			@addresses = current_user.addresses
		end
	end

	def choose_shipping_address
		session[:billing_address_id] = params[:address_id]
		if !current_user.addresses.present?
			redirect_to my_account_path
		else
			@addresses = current_user.addresses
		end
	end

	def order_confirmation
		if session[:billing_address_id]
			@order = current_order
			@shipping_address = current_user.addresses.find(params[:address_id])
			@billing_address = current_user.addresses.find(session[:billing_address_id])
			@order.save_preorder_info(@shipping_address, @billing_address, current_user)
			@cart_items = @order.cart_items
		else
			redirect_to cart_details_cart_items_path, notice: "Please fill address details properly"
		end
	end

	def guest_confirm_order
		if session[:order_id] != nil
			@order = current_order
			@cart_items = @order.cart_items
		else
			redirect_to cart_details_cart_items_path, notice: "Please fill address details properly"
		end
	end

	def bulk_info

	end


	def resource_name
		:user
	end

	def resource
		@resource ||= User.new
	end

	def devise_mapping
		@devise_mapping ||= Devise.mappings[:user]
	end

	private
	def cart_item_params
		params.require(:cart_item).permit(:quantity, :product_id)
	end

	def check_guest_user_access
		redirect_to cart_details_cart_items_path if !current_user  && (current_order.cart_items.size) == 0
	end

	def check_cart_items
		redirect_to cart_details_cart_items_path if (current_order.cart_items.size) == 0
	end

	def check_order
		redirect_to root_path if !current_order
	end



end
