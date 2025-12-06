class RemoveProductIdFromBatches < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :batches, :products, if_exists: true
    remove_column :batches, :product_id, :integer, if_exists: true
  end
end
