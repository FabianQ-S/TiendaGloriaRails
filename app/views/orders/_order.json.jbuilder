json.extract! order, :id, :order_number, :user_id, :address_id, :status, :total, :created_at, :updated_at
json.url order_url(order, format: :json)
