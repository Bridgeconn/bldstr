ActiveAdmin.register Contact do
	index do
		selectable_column
		column :id
		column :full_name
		column :email
		column :phone_number
		actions
	end
	actions :index, :show

end
