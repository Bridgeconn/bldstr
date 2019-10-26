ActiveAdmin.register Category do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	permit_params :name, :description, :image, :parent_id, :short_description, :position, :active
	#
	# or
	#
	# permit_params do
	#   permitted = [:permitted, :attributes]
	#   permitted << :other if params[:action] == 'create' && current_user
	#   permitted
	# end
	index do
		column :name
		column("Parent") { |p| p.parent.name if p.parent.present?  }
		column :position
		column :active
		column :image do |p|
			image_tag p.image_url , width: 80, height: 80 if p.image.present?
		end

		actions
	end

	config.filters = false

	form do |f|
		f.inputs do
			f.input :parent_id, :as => "select", :collection => category_options_array
			f.input :name
			f.input :short_description, :input_html => {:rows => 5, :cols => 20}
			f.input :description, as: :ckeditor, :input_html => { :ckeditor => {:toolbar => 'mini'} }
			f.input :image
			f.input :position
			f.input :active
		end
		f.actions
	end

end
