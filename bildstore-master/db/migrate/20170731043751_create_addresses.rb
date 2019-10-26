class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
    	t.references :user
    	t.string :first_name
    	t.string :last_name
    	t.string :company
    	t.string :postcode
    	t.string :city
        t.string :country
    	t.string :state
    	t.text :address_line1
    	t.text :address_line2
    	t.string :phone_number
    	t.string :type
        t.timestamps null: false
    end
  end
end
