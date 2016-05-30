require 'bodega.rb'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# # *** ----- PRODUCCION ***** -----
# # puts 'PRODUCCION'
# clientes_list = [
# 	["572aac69bdb6d403005fb042", "572aac69bdb6d403005fb04e", "572aad41bdb6d403005fb066", 1],
# 	["572aac69bdb6d403005fb043", "572aac69bdb6d403005fb04f", "572aad41bdb6d403005fb0ba", 2],
# 	["572aac69bdb6d403005fb044", "572aac69bdb6d403005fb050", "572aad41bdb6d403005fb1bf", 3],
# 	["572aac69bdb6d403005fb045", "572aac69bdb6d403005fb051", "572aad41bdb6d403005fb208", 4],
# 	["572aac69bdb6d403005fb046", "572aac69bdb6d403005fb052", "572aad41bdb6d403005fb278", 5],
# 	["572aac69bdb6d403005fb047", "572aac69bdb6d403005fb053", "572aad41bdb6d403005fb2d8", 6],
# 	["572aac69bdb6d403005fb048", "572aac69bdb6d403005fb054", "572aad41bdb6d403005fb3b9", 7],
# 	["572aac69bdb6d403005fb049", "572aac69bdb6d403005fb056", "572aad41bdb6d403005fb416", 8],
# 	["572aac69bdb6d403005fb04a", "572aac69bdb6d403005fb057", "572aad41bdb6d403005fb4b8", 9],
# 	["572aac69bdb6d403005fb04b", "572aac69bdb6d403005fb058", "572aad41bdb6d403005fb542", 10],
# 	["572aac69bdb6d403005fb04c", "572aac69bdb6d403005fb059", "572aad41bdb6d403005fb5b9", 11],
# 	["572aac69bdb6d403005fb04d", "572aac69bdb6d403005fb05a", "572aad42bdb6d403005fb69f", 12]
# ]



# # *** ----- DEVELOPMENT ***** -----
# # puts 'DEVELOPMENT'
clientes_list = [
	["571262b8a980ba030058ab4f", "571262c3a980ba030058ab5b", "571262aaa980ba030058a147", 1],
	["571262b8a980ba030058ab50", "571262c3a980ba030058ab5c", "571262aaa980ba030058a14e", 2],
	["571262b8a980ba030058ab51", "571262c3a980ba030058ab5d", "571262aaa980ba030058a1f1", 3],
	["571262b8a980ba030058ab52", "571262c3a980ba030058ab5f", "571262aaa980ba030058a240", 4],
	["571262b8a980ba030058ab53", "571262c3a980ba030058ab61", "571262aaa980ba030058a244", 5],
	["571262b8a980ba030058ab54", "571262c3a980ba030058ab62", "0", 6],
	["571262b8a980ba030058ab55", "571262c3a980ba030058ab60", "0", 7],
	["571262b8a980ba030058ab56", "571262c3a980ba030058ab5e", "571262aaa980ba030058a31e", 8],
	["571262b8a980ba030058ab57", "571262c3a980ba030058ab66", "571262aaa980ba030058a3b0", 9],
	["571262b8a980ba030058ab58", "571262c3a980ba030058ab63", "571262aaa980ba030058a40c", 10],
	["571262b8a980ba030058ab59", "571262c3a980ba030058ab64", "571262aaa980ba030058a488", 11],
	["571262b8a980ba030058ab5a", "571262c3a980ba030058ab65", "571262aba980ba030058a5c6", 12]
]



puts "Creando Clientes"
clientes_list.each do |_idGrupo, _idBanco, _idAlmacenRecepcion, grupo|
	cliente = Cliente.create(_idGrupo: _idGrupo, _idBanco: _idBanco, _idAlmacenRecepcion: _idAlmacenRecepcion, grupo: grupo)
	cliente.save!
end	


Spree::Auth::Engine.load_seed if defined?(Spree::Auth)



# *** ---- SPREE ---- ***

puts "Creando Tax Category"
tax_category = Spree::TaxCategory.create(name: 'IVA',is_default: true)
tax_category.save


puts "Creando Tax Rate"
tax_rate = Spree::TaxRate.create(amount: 0.19, tax_category_id: 1, included_in_price: true)
tax_rate.save


puts "Creando Productos"
#Test
#product = Spree::Product.create(name: 'ProductoPrueba', description: 'prueba', available_on: Time.now, shipping_category: Spree::ShippingCategory.find_by(id: 1), price: 1000)
#product.save

productos_list = [
	["Pollo", "Los mejores pollos del mundo, elevados al aire libre y alimentados por semillas nacidas de la agricultura biológica.", Time.now, "pollo", 1159, "carne-di-pollo-eurocarne.jpg", "1"],
	["Pan Marraqueta", "Un pan rico y tradicional.", Time.now, "pan marraqueta", 15718, "marraqueta.jpg", "10"],
	["Harina", "Una harina rica y preparada con mucho amor.", Time.now, "harina", 4294, "harina.jpg", "23"],
	["Uva", "Uva biologico cultivado en Chile.", Time.now, "uva", 1217, "uva.jpg", "39"]
]

productos_list.each do |name, description, available_on, meta_keywords, price, image_name, sku|
	product = Spree::Product.create(sku: sku, cost_currency: "CLP", name: name, description: description, available_on: available_on, meta_keywords: meta_keywords, tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: price)
  path = 'public/spree/products/' + sku + '/product/' + image_name
  id = Spree::Variant.find_by(product_id: product.id).id
	i = Spree::Image.create!(attachment: File.open(path), viewable_type: "Spree::Variant", viewable_id: id, attachment_file_name: image_name)
  product.images << i
  product.save
  #path = 'public/spree/products/' + sku + '/product/' + image_name +'.jpg'
#   image = Spree::Image.create(attachment: File.open(path), viewable: product.master, viewable_id: product.id, viewable_type: 'Spree::Variant', attachment_file_name: image_name , type: "Spree::Image")
# image.save
# product.save
end

# puts "Creando Variants"
# variants_list = [
# 	["1", 1, Spree::Product.find_by_name('Pollo').id, Bodega.first.checkStockTotal(1)],
# 	["10", 1, Spree::Product.find_by_name('Pan Marraqueta').id, Bodega.first.checkStockTotal(10)],
# 	["23", 1, Spree::Product.find_by_name('Farina').id, Bodega.first.checkStockTotal(23)],
# 	["39", 1, Spree::Product.find_by_name('Uva').id, Bodega.checkStockTotal(39)]
# ]
# variants_list.each do |sku, weight, product_id, stock_items_count|
# 	variant = Spree::Variant.create(sku: sku, weight: weight, is_master: true, product_id: product_id, updated_at: Time.now, stock_items_count: stock_items_count)
# 	variant.save
# end





