ActiveAdmin.register User do
	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	# permit_params :list, :of, :attributes, :on, :model
	permit_params :first_name, :last_name, :email, :password, :password_confirmation

	#
	# or
	#
	# permit_params do
	#   permitted = [:permitted, :attributes]
	#   permitted << :other if params[:action] == 'create' && current_user.admin?
	#   permitted
	# end

	filter :first_name
	filter :last_name
	filter :email
	filter :last_sign_in_at
	filter :last_sign_in_ip

	form do |f|
		f.inputs do
			f.input :first_name
			f.input :last_name
			f.input :email
			f.input :phone_number
			f.input :password
			f.input :password_confirmation
		end
		# f.has_many :addresses do |address|
		# 	address.input :first_name
		# 	address.input :last_name
		# 	address.input :country
		# 	address.input :postcode
		# 	address.input :city
		# 	address.input :state
		# 	address.input :address_line1
		# 	address.input :address_line2
		# 	address.input :phone_number
		# end
		f.actions
	end

	index do
		selectable_column
		column :id
		column :first_name
		column :last_name
		column :email
		column :role do |user|
			if user.is_admin?
				"Admin"
			else
				"User"
			end
		end
		actions
	end


	controller do
		def create
			@user = User.new(user_params)
			@user.skip_confirmation!
			if @user.save
				redirect_to admin_users_path, notice: "User created successfully."
			else
				render :new
			end
		end

		def user_params
			params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
		end
	end



end
