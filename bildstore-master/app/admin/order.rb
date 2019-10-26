ActiveAdmin.register Order do
	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	permit_params :billing_first_name, :billing_last_name, :billing_email, :user_id, :status, :billing_country, :billing_city, :total_amount, :subtotal
	#
	# or
	#
	# permit_params do
	# 	permitted = [:permitted, :attributes]
	# 	permitted << :other if params[:action] == 'create' && current_user.is_admin?
	# 	permitted
	# end

	filter :billing_first_name
	filter :billing_last_name
	filter :shipping_first_name
	filter :shipping_last_name
	filter :order_status

	controller do
		def scoped_collection
			Order.where("status = ?", 3).or(Order.where("status =?", 4))
		end
	end


	index do
		column :id
		column :billing_email
		column (:total_amount) { |ta| number_to_currency(ta.total_amount) }
		column :status
		column :created_at

		actions
	end


	show do
		panel "Order Details"  do
			attributes_table_for order do
				row :billing_email
				row :shipping_first_name
				row :shipping_last_name
				row :shipping_address_1
				row :shipping_address_2
				row :shipping_city
				row("Shipping Country") { |p| country_name(p.shipping_country) }
				row("Shipping State") { |p| state_name(p.shipping_country, p.shipping_state) }
				row :shipping_zip
				row :shipping_phone

				row :billing_first_name
				row :billing_last_name
				row :billing_address_1
				row :billing_address_2
				row :billing_city
				row("billing Country") { |p| country_name(p.billing_country) }
				row("billing State") { |p| state_name(p.billing_country, p.billing_state) }
				row :billing_zip
				row :billing_phone
				row :status
				row(:total_amount) { |o| number_to_currency(o.total_amount)}
				row(:payment_datetime)
				table_for order.cart_items do
			      column :product_name 
			      column :quantity
			      column :"Item Price" do |item|
			       number_to_currency(item.unit_price)
			      end
			      column :"Price Total" do |item| 
			      	number_to_currency(item.total_price)
			      end
			    end
			    table_for order do
			    	column :""
			    	column :""
			    	column :""
			    	column :"Grand Total" do |order| 
			    		number_to_currency(order.total_amount)
			    	end
			    end

			end
		end
	end

	form do |f|
		f.inputs do

			f.input :status

			f.input :billing_email
			f.input :billing_first_name
			f.input :billing_last_name
			f.input :billing_company
			f.input :billing_address_1
			f.input :billing_address_2
			f.input :billing_city
			f.input :billing_country
			f.input :billing_state
			f.input :billing_zip
			f.input :billing_phone

			f.input :shipping_first_name
			f.input :shipping_last_name
			f.input :shipping_address_1
			f.input :shipping_address_2
			f.input :shipping_city
			f.input :shipping_country
			f.input :shipping_state
			f.input :shipping_zip
			f.input :shipping_phone

		end

		f.actions
	end
	actions :index, :show, :edit
end
