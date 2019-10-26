class Product < ApplicationRecord
	include PgSearch
	belongs_to :category
	has_many :recent_product_visits
	# belongs_to :edition

	extend FriendlyId
	friendly_id :name, use: [:slugged, :finders]

	validates_uniqueness_of :slug
	validates_presence_of :name, :slug

	pg_search_scope :search, against: %i(name description), using: {tsearch: { any_word: true, dictionary: "english", prefix: true }}

	scope :active_product, -> { where("active = ?", true).order('position asc') }

	# scope :recent_product_visit, ->(user_id) {where("product_id = ? and user_id = ?", self.id, user_id).order('created_at asc')}

	mount_uploader :image, ProductImageUploader

	def update_recent_item(user)
		if user.recent_product_visits.size == 4
			exist_last_product = RecentProductVisit.where("user_id = ? and product_id =? ", user.id, self.id).order('created_at asc').limit(1).first
			if (!exist_last_product)
				user_last_product = RecentProductVisit.where("user_id = ?", user.id).order('created_at asc').limit(1).first
				user_last_product.update_attributes(product_id: self.id, user_id: user.id)
			end
		else
			exist_recent_product = user.recent_product_visits.find_by(product_id: self.id)
			if(exist_recent_product)
				exist_recent_product.update_attributes(product_id: self.id)
			else
				user.recent_product_visits.create(product_id: self.id)
			end
		end
	end

end
