class CreateEditions < ActiveRecord::Migration[5.1]
  def change
    create_table :editions do |t|
    	t.string :name
    	t.text :description
      t.timestamps null: false
    end
  end
end
