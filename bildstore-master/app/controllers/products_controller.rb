class ProductsController < ApplicationController
	skip_before_action :authenticate_user!

	def category_product
		@category = Category.friendly.find(params[:id])
		@products = @category.products.active_product
	end

	def show
		@product = Product.friendly.find(params[:id])
		@product.update_recent_item(current_user) if current_user
	end

	def search_product
		@products = Product.search(params[:query]).active_product.page(params[:page]).per(2)
	end

end
