class ChangeAddressIdNullableInOrders < ActiveRecord::Migration[8.1]
  def change
    change_column_null :orders, :address_id, true
  end
end
