json.extract! product, :id, :sku, :name, :description, :price, :image_url, :category_id, :provider_id, :is_perishable, :created_at, :updated_at
json.url product_url(product, format: :json)
