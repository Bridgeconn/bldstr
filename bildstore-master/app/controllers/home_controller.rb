class HomeController < ApplicationController

	skip_before_action :authenticate_user!

	def index
		@category = Category.active_category.where(name: "Resources").first
		@childrens = @category.children.active_category if @category
	end

	def account_created
	end

	def privacy_policy

	end

	def terms_conditions
	end

	def privacy_policy

	end

	def shipping_policy
	end

end
