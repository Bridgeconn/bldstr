class OrdersController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:redirect_url, :cancel_url, :create]
	# skip_before_action :authenticate_user!
	# before_action :check_order, only: [:guest_order_completed]
	def new
		@order = current_order
	end

	def order_params(params, order)
		{
			"billing_email" => order.billing_email ,
			"merchant_id" => ENV["merchant_id"],
			"order_id" => order.id.to_s,
			"amount" => order.subtotal.to_s.to_f.round(2),
			"currency" => order.currency,
			"redirect_url" => redirect_url_orders_url,
			"cancel_url" => cancel_url_orders_url,
			"language" => "EN",
			"billing_name" => order.billing_full_name,
			"billing_address" => order.billing_full_address,
			"billing_city" => order.billing_city,
			"billing_state" => state_name(order.billing_country, order.billing_state),
			"billing_zip" => order.billing_zip,
			"billing_country" => country_name(order.billing_country),
			"billing_tel" => order.billing_phone,

			"delivery_name" => order.shipping_full_name,
			"delivery_address" => order.shipping_full_address,
			"delivery_city" => order.shipping_city,
			"delivery_state" => state_name(order.shipping_country, order.shipping_state),
			"delivery_zip" => order.shipping_zip,
			"delivery_country" => country_name(order.shipping_country),
			"delivery_tel" => order.shipping_phone,
		}
	end

	def create
		@order = current_order
		begin
			session.delete(:order_id)
			session[:billing_address_id] = nil
			@order.status = 2
			@order.user_id = current_user.id if current_user
			@order.save

			#========== commented razor pay code for now================
			# begin
			# 	@payment_order = Order.process_razorpayment(payment_params)
			# 	session[:billing_address_id] = nil
			# 	session[:order_id] = nil
			# 	redirect_to orders_completed_users_path
			# rescue Exception => e
			# 	# @order.create_order_transaction(params: razorpay_pmnt_obj.attributes, success: false, message: "Transaction failed");
			# 	flash[:alert] = "Unable to process payment."
			# 	redirect_to root_path
			# end
			#========== commented razor pay code for now================


			# if current_user
			# 	redirect_to orders_completed_users_path
			# else
			# 	redirect_to guest_order_completed_orders_path
			# end
			merchantData=""
			@working_key=  ENV["ccavenue_key"]#"53FAD9E38198B14A437A08DA2CD0833C"   #Put in the 32 Bit Working Key provided by CCAVENUES.
			@access_code= ENV["ccavenue_access_code"]   #Put in the Access Code in quotes provided by CCAVENUES.
			order_req = order_params(params, @order)
			@merchant_id = ENV["merchant_id"]
			@request_url = ENV["request_url"]
			crypto = Crypto.new
			@encrypted_data = crypto.encrypt(order_req.to_query, @working_key)
		rescue Exception => e
			redirect_to cart_details_cart_items_path,	 notice: "Please retry for ther order"
		end
	end

	def cancel_url
		@working_key= ENV["ccavenue_key"]
		crypto = Crypto.new
		decrypted_data = crypto.decrypt(params["encResp"], @working_key)
		gateway_response = Rack::Utils.parse_nested_query(decrypted_data)
		order = Order.find(gateway_response["order_id"])
		order.update_order(gateway_response, 1)
	end

	def update
		@order = current_order
		action = guest_shipping_address_cart_items_path
		if params[:ship_to_billing] && params[:ship_to_billing] == "1"
			@order.shipping_first_name = order_field_params[:billing_first_name]
			@order.shipping_last_name = order_field_params[:billing_last_name]
			@order.shipping_country = order_field_params[:billing_country]
			@order.shipping_zip = order_field_params[:billing_zip]
			@order.shipping_city = order_field_params[:billing_city]
			@order.shipping_state = order_field_params[:billing_state]
			@order.shipping_address_1 = order_field_params[:billing_address_1]
			@order.shipping_address_2 = order_field_params[:billing_address_2]
			@order.shipping_phone = order_field_params[:billing_phone]
			action = guest_confirm_order_cart_items_path
		end
		# redirect = params[:address_type] == "billing" ? "dada" : guest_confirm_order_cart_items_path
		redirect_url = (params[:address_type] == "billing" ? action : guest_confirm_order_cart_items_path)
		if !current_user && @order.update_attributes(order_field_params)
			redirect_to redirect_url
		else
			redirect_to root_path
		end
	end

	def guest_shipping_address

	end

	def show
		@order = current_user.orders.find(params[:id])
	end

	def invoice
		@order = current_user.orders.find(params[:id])
		render layout: false
	end

	def guest_order_invoice
		if session[:temp_access]
			@order = Order.find(params[:id])
			session.delete(:temp_access)
			render layout: false
		end
	end

	def print_invoice
		@order = current_user.orders.find(params[:id])
		render layout: false
	end

	def redirect_url
		begin
			@working_key= ENV["ccavenue_key"]
			crypto = Crypto.new
			decrypted_data = crypto.decrypt(params["encResp"], @working_key)
			gateway_response = Rack::Utils.parse_nested_query(decrypted_data)
			order = Order.find(gateway_response["order_id"])
			if gateway_response["order_status"].downcase == "success"
				order.update_order(gateway_response, 3)
				OrderMailer.send_order_summary(order.billing_email, order).deliver
				if current_user
					redirect_to order_path(order)
				else
					session[:temp_access] = true
					redirect_to guest_order_completed_order_path(order)
				end
			else
				order.update_order(gateway_response, 1)
				OrderMailer.send_order_issue(order.billing_email, order).deliver
				redirect_to order_cancel_orders_path
			end
		rescue Exception => e
			redirect_to order_cancel_orders_path
		end
	end

	def guest_order_completed
		if session[:temp_access]
			@order = Order.find(params[:id])
		else
			redirect_to root_path
		end
	end


	def order_confirmation
		@order = current_order
	end

	private

	def order_field_params
		params.require(:order).permit(:billing_email, :billing_first_name, :billing_last_name,
																	:billing_company, :billing_country, :billing_zip, :billing_city, :billing_state, :billing_address_1, :billing_address_2, :billing_phone,
																	:shipping_first_name, :shipping_last_name, :shipping_company, :shipping_country, :shipping_zip,
																	:shipping_state, :shipping_city, :shipping_address_1, :shipping_address_2, :shipping_phone)
	end

	def check_order
		redirect_to root_path if current_order.new_record?
	end

end
