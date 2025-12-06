class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :name
      t.text :description
      t.decimal :price
      t.string :image_url
      t.references :category, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true
      t.boolean :is_perishable

      t.timestamps
    end
  end
end
