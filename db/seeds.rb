# Seeds para Gloria Lácteos E-commerce
# Ejecutar con: rails db:seed

puts "🥛 Iniciando seeds para Gloria Lácteos..."

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

# Crear Proveedores
puts "🚚 Creando proveedores..."
provider_gloria = Provider.find_or_create_by!(name: "Gloria S.A.") do |p|
  p.contact_email = "contacto@gloria.com.pe"
end
provider_laive = Provider.find_or_create_by!(name: "Laive S.A.") do |p|
  p.contact_email = "ventas@laive.com.pe"
end
puts "   Proveedores: Gloria S.A., Laive S.A."

# Crear Categorías
puts "🏷️ Creando categorías..."
categories = ["Leches", "Yogurts", "Quesos", "Mantequillas", "Cremas", "Jugos"]
created_categories = {}
categories.each do |name|
  cat = Category.find_or_create_by!(name: name)
  created_categories[name] = cat
  puts "   Categoría: #{name}"
end

# Crear Lotes primero (sin product_id)
puts "📋 Creando lotes..."
batches_data = [
  { batch_number: "LOTE-2025-001", quantity: 500, expiration_date: Date.current + 60.days },
  { batch_number: "LOTE-2025-002", quantity: 300, expiration_date: Date.current + 45.days },
  { batch_number: "LOTE-2025-003", quantity: 200, expiration_date: Date.current + 90.days },
  { batch_number: "LOTE-2025-004", quantity: 100, expiration_date: Date.current + 30.days },
  { batch_number: "LOTE-VENCIDO-001", quantity: 50, expiration_date: Date.current - 10.days }, # Lote vencido para demo
]

created_batches = {}
batches_data.each do |data|
  batch = Batch.find_or_create_by!(batch_number: data[:batch_number]) do |b|
    b.quantity = data[:quantity]
    b.expiration_date = data[:expiration_date]
  end
  created_batches[data[:batch_number]] = batch
  status = batch.expiration_date < Date.current ? "⚠️ VENCIDO" : "✓"
  puts "   Lote: #{data[:batch_number]} - #{status}"
end

# Crear Productos con stock y lote asignado
puts "📦 Creando productos..."
products_data = [
  { sku: "LECHE-001", name: "Leche Gloria Entera 1L", description: "Leche entera de vaca, rica en calcio y vitaminas.", price: 5.50, category: "Leches", stock: 150, batch: "LOTE-2025-001" },
  { sku: "LECHE-002", name: "Leche Gloria Descremada 1L", description: "Leche descremada, baja en grasa.", price: 5.80, category: "Leches", stock: 100, batch: "LOTE-2025-001" },
  { sku: "LECHE-003", name: "Leche Gloria Evaporada 400g", description: "Leche evaporada ideal para postres y bebidas.", price: 4.20, category: "Leches", stock: 200, batch: "LOTE-2025-002" },
  { sku: "YOG-001", name: "Yogurt Gloria Fresa 1L", description: "Yogurt con trozos de fresa natural.", price: 8.50, category: "Yogurts", stock: 80, batch: "LOTE-2025-002" },
  { sku: "YOG-002", name: "Yogurt Gloria Natural 1L", description: "Yogurt natural sin azúcar añadida.", price: 7.90, category: "Yogurts", stock: 60, batch: "LOTE-2025-003" },
  { sku: "YOG-003", name: "Yogurt Gloria Vainilla 500ml", description: "Delicioso yogurt con sabor a vainilla.", price: 4.50, category: "Yogurts", stock: 0, batch: nil }, # Agotado para demo
  { sku: "QUESO-001", name: "Queso Edam Gloria 250g", description: "Queso tipo Edam, ideal para sándwiches.", price: 12.50, category: "Quesos", stock: 40, batch: "LOTE-2025-003" },
  { sku: "QUESO-002", name: "Queso Parmesano Gloria 100g", description: "Queso parmesano rallado premium.", price: 9.90, category: "Quesos", stock: 30, batch: "LOTE-2025-004" },
  { sku: "MANT-001", name: "Mantequilla Gloria 200g", description: "Mantequilla con sal, cremosa y suave.", price: 8.00, category: "Mantequillas", stock: 50, batch: nil },
  { sku: "CREMA-001", name: "Crema de Leche Gloria 200ml", description: "Crema de leche para cocinar y batir.", price: 6.50, category: "Cremas", stock: 70, batch: nil },
  { sku: "JUGO-001", name: "Jugo Gloria Naranja 1L", description: "Jugo natural de naranja sin preservantes.", price: 5.90, category: "Jugos", stock: 90, batch: "LOTE-2025-004" },
  { sku: "JUGO-002", name: "Jugo Gloria Mango 1L", description: "Delicioso jugo de mango tropical.", price: 5.90, category: "Jugos", stock: 25, batch: "LOTE-VENCIDO-001" }, # Producto vencido para demo
]

products_data.each do |data|
  product = Product.find_or_initialize_by(sku: data[:sku])
  product.assign_attributes(
    name: data[:name],
    description: data[:description],
    price: data[:price],
    category: created_categories[data[:category]],
    provider: provider_gloria,
    is_perishable: true,
    stock: data[:stock],
    batch: data[:batch] ? created_batches[data[:batch]] : nil
  )
  product.save!
  
  status = if product.stock == 0
    "❌ AGOTADO"
  elsif product.batch&.expired?
    "⚠️ VENCIDO"
  else
    "✓ #{product.stock} unidades"
  end
  puts "   #{data[:name]} - #{status}"
end

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
puts "   - Lotes: #{Batch.count}"
puts "   - Productos: #{Product.count}"
puts ""
puts "🔑 Credenciales de acceso:"
puts "   Admin: admin@gloria.com / admin123"
puts "   Cliente: cliente@test.com / cliente123"
puts ""
puts "📦 Productos de demo:"
puts "   - Yogurt Vainilla: AGOTADO (stock = 0)"
puts "   - Jugo Mango: VENCIDO (lote expirado)"
puts ""
