class Order < ApplicationRecord
	paginates_per  5
	# belongs_to :order_status, optional: true
	belongs_to :user, optional: true
	has_many :cart_items, dependent: :destroy
	before_create :set_order_status
	before_save :update_subtotal_total

	has_one :order_transaction, dependent: :destroy

	enum status: [ :initiated, :cancelled, :in_progress, :completed, :shipped ]

	scope :recent_cancelled_order, -> {where("status = ? ", 1).order('created_at desc').limit(1)}


	def cart_total_price
		self.cart_items.to_a.sum(&:total_price)
	end

	def subtotal
		cart_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
	end

	def get_details
		order_items.collect{|f| {:name => f.product.name, :quantity => f.quantity.to_i, :amount => f.product.unit_price_in_cents}}
	end

	def cart_total_amount  #####cart total amount method calculate amount ######
		subtotal
	end

	def amount_in_integer
		(subtotal.to_f.round(2)*100).to_i
	end


	def billing_full_name
		"#{billing_first_name} #{billing_last_name}"
	end

	def shipping_full_name
		"#{shipping_first_name} #{shipping_last_name}"
	end

	def billing_full_address
		"#{billing_address_1} #{billing_address_2}"
	end


	def shipping_full_address
		"#{shipping_address_1} #{shipping_address_2}"
	end

	def save_preorder_info(shipping_address, billing_address, current_user)
		order_req = {
			"billing_email" => current_user.present? ? current_user.email : "" ,
			"currency" => "INR",
			"language" => "EN",
			"billing_first_name" => billing_address.first_name,
			"billing_last_name" => billing_address.last_name,
			"billing_address_1" => billing_address.address_line1,
			"billing_city" => billing_address.city,
			"billing_state" => billing_address.state,
			"billing_zip" => billing_address.postcode,
			"billing_country" => billing_address.country,
			"billing_phone" => billing_address.phone_number,

			"shipping_first_name" => shipping_address.first_name,
			"shipping_last_name" => shipping_address.last_name,
			"shipping_address_1" => shipping_address.address_line1,
			"shipping_city" => shipping_address.city,
			"shipping_state" => shipping_address.state,
			"shipping_zip" => shipping_address.postcode,
			"shipping_country" => shipping_address.country,
			"shipping_phone" => shipping_address.phone_number,
		}
		update_attributes(order_req)
	end

	def update_order(params, order_status)
		self.status = order_status
		self.ccavenue_tracking_id = params["tracking_id"]
		self.ccavenue_order_status = status
		self.payment_mode = params["payment_mode"]
		self.payment_datetime = params["trans_date"]
		self.save
		# create_order_transaction(params: params, success: (order_status.downcase == "completed" ? true : false), message: params["failure_message"]  )
	end



	# class << self
	# 	def process_razorpayment(params)
	# 		razorpay_pmnt_obj = fetch_payment(params[:payment_id])
	# 		status = fetch_payment(params[:payment_id]).status
	# 		razorpay_pmnt_obj = fetch_payment(params[:payment_id])
	# 		if status == "authorized"
	# 			order = Order.find(params[:order_id])
	# 			razorpay_pmnt_obj.capture({amount: order.amount_in_integer})
	# 			# params.merge!({status: razorpay_pmnt_obj.status, price: order.amount_in_integer})
	# 			order.update_attributes(razorpay_payment_id: razorpay_pmnt_obj.id,
	# 															razorpay_status: razorpay_pmnt_obj.status )
	# 			order.create_order_transaction(params: razorpay_pmnt_obj.to_json, success: true, message: "Transaction succeed");
	# 		else
	# 			order.create_order_transaction(params: razorpay_pmnt_obj.to_json, success: false, message: "Transaction failed");
	# 			raise StandardError, "UNable to capture payment"
	# 		end
	# 	end
	# end


	private

	def set_order_status
		self.order_status_id = 0
	end

	def update_subtotal_total
		self[:subtotal] = subtotal
		self[:total_amount] = subtotal
		self[:currency] = "INR"
	end


end
