class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
    	t.integer :parent_id
      t.string :name, null: false
      t.string :slug, null: false, unique: true
      t.text :description
      t.boolean :active, default: true
      t.string :image
      t.timestamps null: false
    end
  end
end
