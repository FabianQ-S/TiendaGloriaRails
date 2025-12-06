json.extract! batch, :id, :product_id, :batch_number, :expiration_date, :quantity, :created_at, :updated_at
json.url batch_url(batch, format: :json)
