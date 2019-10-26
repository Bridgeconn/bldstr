class Category < ApplicationRecord
	belongs_to :parent, :class_name => "Category", optional: true
	has_many :children, :class_name => "Category", :foreign_key => 'parent_id'
	has_many :products, dependent: :destroy

	extend FriendlyId
	friendly_id :name, use: [:slugged, :finders]

	mount_uploader :image, CategoryImageUploader

	scope :active_category, -> { where("active = ?", true).order('position asc') }




	def descendents
		children.map do |child|
			[child] + child.descendents
		end.flatten
	end
end
