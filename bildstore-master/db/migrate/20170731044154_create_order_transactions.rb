class CreateOrderTransactions < ActiveRecord::Migration[5.1]
	def change
		create_table :order_transactions do |t|
			t.integer :order_id
			t.boolean :success
			t.text :message
			t.text :params
			t.timestamps null: false
		end
	end
end
