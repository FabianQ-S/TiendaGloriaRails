class AddBatchIdToProducts < ActiveRecord::Migration[8.1]
  def change
    add_reference :products, :batch, null: true, foreign_key: true
  end
end
