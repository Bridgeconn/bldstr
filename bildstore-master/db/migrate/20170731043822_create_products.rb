class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
    	t.references :category
      t.references :edition
      t.string :name, null: false, default: ""
      t.string :slug, null: false, unique: true
      t.text :description
      t.decimal :price, null: false, default: ""
      t.boolean :active, default: true
      t.decimal :price, null: false, default: 0
      t.string :image
      t.integer :quantity, default: 0
      t.timestamps null: false
    end
     	add_index :products, :slug, unique: true
    	add_index :products, :name
  end
end
