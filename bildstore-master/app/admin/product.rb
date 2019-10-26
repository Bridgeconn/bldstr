ActiveAdmin.register Product do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	permit_params :name, :description, :price, :image, :quantity, :category_id, :active, :quantity, :position
	#
	# or
	#
	# permit_params do
	#   permitted = [:permitted, :attributes]
	#   permitted << :other if params[:action] == 'create' && current_user.admin?
	#   permitted
	# end

	filter :id
	filter :name
	filter :category

	index do
		column :id
		column :name
		column :category
		column :image do |p|
			image_tag p.image_url , width: 80, height: 80 if p.image.present?
		end
		column :price do |product|
			number_to_currency product.price
		end
		column :quantity
		column :position
		column :active

		actions
	end

	form title: 'Product Edit' do |f|
		inputs 'Details' do
			input :name
			input :category, :as => "select", :collection => category_options_array
			input :price
			input :description, as: :ckeditor, :input_html => { :ckeditor => {:toolbar => 'mini'} }
			input :image
			input :quantity
			input :active
			input :position
		end
		actions
	end


end
