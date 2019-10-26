class OrderMailer < ApplicationMailer
	include ApplicationHelper
	default from: "Bild Internationl India Store <orders@bildstore.in>"
	def send_order_summary(user_email, order)
		@order = order
		@billing_state_name = state_name(@order.billing_country, @order.billing_state)
		@shipping_state_name = state_name(@order.shipping_country, @order.shipping_state)
		@billing_country_name = country_name(@order.billing_country)
		@shipping_country_name = country_name(@order.shipping_country)
		mail(:to => [user_email], bcc: "orders@bildstore.in" , :subject => "Your BILD International India Store Order Confirmation (# #{order.id})") do |format|
			format.html
		end
	end

	def send_order_issue(user_email, order)
		@order = order
		@billing_state_name = state_name(@order.billing_country, @order.billing_state)
		@shipping_state_name = state_name(@order.shipping_country, @order.shipping_state)
		@billing_country_name = country_name(@order.billing_country)
		@shipping_country_name = country_name(@order.shipping_country)
		mail(:to => [user_email]  , bcc: "orders@bildstore.in", :subject => "Your BILD International India Store Order issue (# #{order.id})") do |format|
			format.html
		end
	end
end
