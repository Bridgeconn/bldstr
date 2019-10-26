class AddPositionToCategoryAndProduct < ActiveRecord::Migration[5.1]
	def change
		add_column :categories, :position, :integer, default: 0
		add_column :products, :position, :integer, default: 0
		add_column :categories, :short_description, :text
	end
end
