class CreateRecentProductVisits < ActiveRecord::Migration[5.1]
	def change
		create_table :recent_product_visits do |t|
			t.references :user, index: true
			t.references :product, index: true
			t.timestamps
		end
	end
end
