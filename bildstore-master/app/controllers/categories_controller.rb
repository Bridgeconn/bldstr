class CategoriesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:show]

	def show
		@category = Category.friendly.find(params[:id])
		@childrens = @category.children.order('created_at asc')
	end
end
