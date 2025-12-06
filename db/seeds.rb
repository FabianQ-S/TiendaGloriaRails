# Seeds para Gloria Lácteos E-commerce
# Ejecutar con: rails db:seed

puts "🥛 Iniciando seeds para Gloria Lácteos..."

# Limpiar datos existentes (opcional)
# OrderItem.destroy_all
# Order.destroy_all
# Batch.destroy_all
# Product.destroy_all
# Category.destroy_all
# Provider.destroy_all
# Address.destroy_all
# User.destroy_all
# Role.destroy_all

# Crear Roles
puts "🔐 Creando roles..."
admin_role = Role.find_or_create_by!(name: "Admin")
client_role = Role.find_or_create_by!(name: "Cliente")
puts "   Roles creados: Admin, Cliente"

# Crear Usuario Admin
puts "👤 Creando usuario administrador..."
admin = User.find_or_initialize_by(email: "admin@gloria.com")
admin.assign_attributes(
  name: "Administrador Gloria",
  password: "admin123",
  password_confirmation: "admin123",
  role: admin_role,
  active: true
)
admin.save!
puts "   Admin creado: admin@gloria.com / admin123"

# Crear Usuario de prueba
puts "👤 Creando usuario de prueba..."
test_user = User.find_or_initialize_by(email: "cliente@test.com")
test_user.assign_attributes(
  name: "Cliente de Prueba",
  password: "cliente123",
  password_confirmation: "cliente123",
  role: client_role,
  active: true
)
test_user.save!
puts "   Cliente creado: cliente@test.com / cliente123"

# Crear Proveedor
puts "🚚 Creando proveedor..."
provider = Provider.find_or_create_by!(name: "Gloria S.A.") do |p|
  p.contact_email = "contacto@gloria.com.pe"
end
puts "   Proveedor: Gloria S.A."

# Crear Categorías
puts "🏷️ Creando categorías..."
categories = {
  "Leches" => nil,
  "Yogurts" => nil,
  "Quesos" => nil,
  "Mantequillas" => nil,
  "Cremas" => nil,
  "Jugos" => nil
}

created_categories = {}
categories.each do |name, parent|
  cat = Category.find_or_create_by!(name: name) do |c|
    c.parent_id = parent
  end
  created_categories[name] = cat
  puts "   Categoría: #{name}"
end

# Crear Productos
puts "📦 Creando productos..."
products_data = [
  { sku: "LECHE-001", name: "Leche Gloria Entera 1L", description: "Leche entera de vaca, rica en calcio y vitaminas.", price: 5.50, category: "Leches", is_perishable: true },
  { sku: "LECHE-002", name: "Leche Gloria Descremada 1L", description: "Leche descremada, baja en grasa.", price: 5.80, category: "Leches", is_perishable: true },
  { sku: "LECHE-003", name: "Leche Gloria Evaporada 400g", description: "Leche evaporada ideal para postres y bebidas.", price: 4.20, category: "Leches", is_perishable: false },
  { sku: "YOG-001", name: "Yogurt Gloria Fresa 1L", description: "Yogurt con trozos de fresa natural.", price: 8.50, category: "Yogurts", is_perishable: true },
  { sku: "YOG-002", name: "Yogurt Gloria Natural 1L", description: "Yogurt natural sin azúcar añadida.", price: 7.90, category: "Yogurts", is_perishable: true },
  { sku: "YOG-003", name: "Yogurt Gloria Vainilla 500ml", description: "Delicioso yogurt con sabor a vainilla.", price: 4.50, category: "Yogurts", is_perishable: true },
  { sku: "QUESO-001", name: "Queso Edam Gloria 250g", description: "Queso tipo Edam, ideal para sándwiches.", price: 12.50, category: "Quesos", is_perishable: true },
  { sku: "QUESO-002", name: "Queso Parmesano Gloria 100g", description: "Queso parmesano rallado premium.", price: 9.90, category: "Quesos", is_perishable: true },
  { sku: "MANT-001", name: "Mantequilla Gloria 200g", description: "Mantequilla con sal, cremosa y suave.", price: 8.00, category: "Mantequillas", is_perishable: true },
  { sku: "CREMA-001", name: "Crema de Leche Gloria 200ml", description: "Crema de leche para cocinar y batir.", price: 6.50, category: "Cremas", is_perishable: true },
  { sku: "JUGO-001", name: "Jugo Gloria Naranja 1L", description: "Jugo natural de naranja sin preservantes.", price: 5.90, category: "Jugos", is_perishable: true },
  { sku: "JUGO-002", name: "Jugo Gloria Mango 1L", description: "Delicioso jugo de mango tropical.", price: 5.90, category: "Jugos", is_perishable: true }
]

products_data.each do |data|
  product = Product.find_or_initialize_by(sku: data[:sku])
  product.assign_attributes(
    name: data[:name],
    description: data[:description],
    price: data[:price],
    category: created_categories[data[:category]],
    provider: provider,
    is_perishable: data[:is_perishable]
  )
  product.save!
  puts "   Producto: #{data[:name]}"
end

# Crear lotes de ejemplo
puts "📋 Creando lotes de ejemplo..."
Product.all.each do |product|
  Batch.find_or_create_by!(product: product, batch_number: "LOTE-#{product.sku}-001") do |b|
    b.quantity = rand(50..200)
    b.expiration_date = Date.current + rand(30..180).days
  end
end
puts "   Lotes creados para todos los productos"

# Crear dirección para usuario de prueba
puts "📍 Creando dirección de prueba..."
Address.find_or_create_by!(user: test_user, name: "Casa") do |a|
  a.street = "Av. Javier Prado 123"
  a.city = "Lima"
  a.district = "San Isidro"
end
puts "   Dirección creada para cliente de prueba"

puts ""
puts "=" * 50
puts "🎉 Seeds completados exitosamente!"
puts "=" * 50
puts ""
puts "📋 Resumen:"
puts "   - Roles: #{Role.count}"
puts "   - Usuarios: #{User.count}"
puts "   - Proveedores: #{Provider.count}"
puts "   - Categorías: #{Category.count}"
puts "   - Productos: #{Product.count}"
puts "   - Lotes: #{Batch.count}"
puts ""
puts "🔑 Credenciales de acceso:"
puts "   Admin: admin@gloria.com / admin123"
puts "   Cliente: cliente@test.com / cliente123"
puts ""
