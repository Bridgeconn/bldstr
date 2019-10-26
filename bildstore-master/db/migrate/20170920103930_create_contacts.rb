class CreateContacts < ActiveRecord::Migration[5.1]
	def change
		create_table :contacts do |t|
			t.string :full_name
			t.string :phone_number
			t.string :email
			t.integer :order_number
			t.text :details
			t.timestamps
		end
	end
end
