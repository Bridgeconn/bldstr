class CreateOrders < ActiveRecord::Migration[5.1]
	def change
		create_table :orders do |t|
			t.decimal :subtotal, precision: 12, scale: 3
			t.decimal :tax, precision: 12, scale: 3
			t.decimal :shipping, precision: 12, scale: 3
			t.decimal :total_amount, precision: 12, scale: 3
			t.references :order_status, index: true
			t.references :user, index: true
			t.string :billing_email
			t.string :language
			t.string :billing_first_name
			t.string :billing_last_name
			t.string :billing_company
			t.string :currency
			t.string :billing_address_1
			t.string :billing_address_2
			t.string :billing_city
			t.string :billing_country
			t.string :billing_zip
			t.string :billing_state
			t.string :billing_phone
			t.string :shipping_first_name
			t.string :shipping_last_name
			t.string :shipping_company
			t.string :shipping_address_1
			t.string :shipping_address_2
			t.string :shipping_city
			t.string :shipping_country
			t.string :shipping_zip
			t.string :shipping_state
			t.string :shipping_phone
			t.string :status
			t.string :ip_address
			t.integer :status, default: 1
			t.datetime :purchased_at
			t.text :notes
			t.boolean :is_ship_to_billing, default: false
			t.string :ccavenue_tracking_id
			t.string :ccavenue_order_status
			t.string :payment_mode
			t.datetime :payment_datetime
			t.timestamps null: false

		end
	end
end
