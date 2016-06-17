require 'bodega.rb'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Cliente.delete_all

# # *** ----- PRODUCCION ***** -----
# puts ' Creando Clientes de PRODUCCION'
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
# puts 'DEVELOPMENT'


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

Spree::Product.delete_all
Spree::Variant.delete_all



# *** ---- SPREE ---- ***

puts "Creando Tax Category"
tax_category = Spree::TaxCategory.create(name: 'IVA',is_default: true)
tax_category.save


puts "Creando Tax Rate"
tax_rate = Spree::TaxRate.create(amount: 0.19, tax_category_id: 1, included_in_price: true)
tax_rate.save


puts "Creando Productos"

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
  	puts "Path: " <<path
  	puts "Image: "
  	puts i


  #path = 'public/spree/products/' + sku + '/product/' + image_name +'.jpg'
#   image = Spree::Image.create(attachment: File.open(path), viewable: product.master, viewable_id: product.id, viewable_type: 'Spree::Variant', attachment_file_name: image_name , type: "Spree::Image")
# image.save
# product.save
end


#Info Saldo
Infosaldo.delete_all

puts "Creando distintos Saldos"

saldos_list =[
	[Date.yesterday, Bodega.first.saldo-10000],
	[Date.yesterday.yesterday, Bodega.first.saldo-24000],
	[Date.yesterday.yesterday.yesterday, Bodega.first.saldo-35000],
	[Date.yesterday.yesterday.yesterday.yesterday, Bodega.first.saldo-10000],
	[Date.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.first.saldo-5000],
	[Date.yesterday.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.first.saldo+15000]
]

saldos_list.each do |fecha, cantidad|
	infosaldo = Infosaldo.create(fecha: fecha, cantidad: cantidad)
	infosaldo.save!
end

#Info Stock
Infostock.delete_all

puts "Creando distintos Stocks"

stock_1_list =[
	['1', Date.yesterday, Bodega.checkStock('1')+20, Bodega.checkStockTotal('1')+20],
	['1', Date.yesterday.yesterday, Bodega.checkStock('1')+200, Bodega.checkStockTotal('1')+200],
	['1', Date.yesterday.yesterday.yesterday, Bodega.checkStock('1')+180, Bodega.checkStockTotal('1')+180],
	['1', Date.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('1')+1200, Bodega.checkStockTotal('1')+1200],
	['1', Date.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('1'), Bodega.checkStockTotal('1')],
	['1', Date.yesterday.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('1')+500, Bodega.checkStockTotal('1')+500]
]

stock_1_list.each do |sku, fecha, cantidadTotal, cantidadDisponible|
	infostock = Infostock.create(sku: sku, fecha: fecha, cantidadTotal: cantidadTotal, cantidadDisponible: cantidadDisponible)
	infostock.save!
end

stock_10_list =[
	['10', Date.yesterday, Bodega.checkStock('10')+20, Bodega.checkStockTotal('10')+20],
	['10', Date.yesterday.yesterday, Bodega.checkStock('10')+200, Bodega.checkStockTotal('10')+200],
	['10', Date.yesterday.yesterday.yesterday, Bodega.checkStock('10')+180, Bodega.checkStockTotal('10')+180],
	['10', Date.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('10')+1200, Bodega.checkStockTotal('10')+1200],
	['10', Date.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('10'), Bodega.checkStockTotal('10')],
	['10', Date.yesterday.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('10')+500, Bodega.checkStockTotal('10')+500]
]

stock_10_list.each do |sku, fecha, cantidadTotal, cantidadDisponible|
	infostock = Infostock.create(sku: sku, fecha: fecha, cantidadTotal: cantidadTotal, cantidadDisponible: cantidadDisponible)
	infostock.save!
end

stock_23_list =[
	['23', Date.yesterday, Bodega.checkStock('23')+20, Bodega.checkStockTotal('23')+20],
	['23', Date.yesterday.yesterday, Bodega.checkStock('23')+200, Bodega.checkStockTotal('23')+200],
	['23', Date.yesterday.yesterday.yesterday, Bodega.checkStock('23')+180, Bodega.checkStockTotal('23')+180],
	['23', Date.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('23')+1200, Bodega.checkStockTotal('23')+1200],
	['23', Date.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('23'), Bodega.checkStockTotal('23')],
	['23', Date.yesterday.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('23')+500, Bodega.checkStockTotal('23')+500]
]

stock_23_list.each do |sku, fecha, cantidadTotal, cantidadDisponible|
	infostock = Infostock.create(sku: sku, fecha: fecha, cantidadTotal: cantidadTotal, cantidadDisponible: cantidadDisponible)
	infostock.save!
end


stock_39_list =[
	['39', Date.yesterday, Bodega.checkStock('39')+20, Bodega.checkStockTotal('39')+20],
	['39', Date.yesterday.yesterday, Bodega.checkStock('39')+200, Bodega.checkStockTotal('39')+200],
	['39', Date.yesterday.yesterday.yesterday, Bodega.checkStock('39')+180, Bodega.checkStockTotal('39')+180],
	['39', Date.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('39')+1200, Bodega.checkStockTotal('39')+1200],
	['39', Date.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('39'), Bodega.checkStockTotal('39')],
	['39', Date.yesterday.yesterday.yesterday.yesterday.yesterday.yesterday, Bodega.checkStock('39')+500, Bodega.checkStockTotal('39')+500]
]

stock_39_list.each do |sku, fecha, cantidadTotal, cantidadDisponible|
	infostock = Infostock.create(sku: sku, fecha: fecha, cantidadTotal: cantidadTotal, cantidadDisponible: cantidadDisponible)
	infostock.save!
end



