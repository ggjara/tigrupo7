# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# clientes_list = [
# 	["571262b8a980ba030058ab4f", "571262c3a980ba030058ab5b", "571262aaa980ba030058a147", 1],
# 	["571262b8a980ba030058ab50", "571262c3a980ba030058ab5c", "571262aaa980ba030058a14e", 2],
# 	["571262b8a980ba030058ab51", "571262c3a980ba030058ab5d", "0", 3],
# 	["571262b8a980ba030058ab52", "571262c3a980ba030058ab5f", "0", 4],
# 	["571262b8a980ba030058ab53", "571262c3a980ba030058ab61", "0", 5],
# 	["571262b8a980ba030058ab54", "571262c3a980ba030058ab62", "0", 6],
# 	["571262b8a980ba030058ab55", "571262c3a980ba030058ab60", "0", 7],
# 	["571262b8a980ba030058ab56", "571262c3a980ba030058ab5e", "571262aaa980ba030058a31e", 8],
# 	["0", "0", "0", 9],
# 	["571262b8a980ba030058ab58", "571262c3a980ba030058ab63", "571262aaa980ba030058a40c", 10],
# 	["571262b8a980ba030058ab59", "571262c3a980ba030058ab64", "0", 11],
# 	["571262b8a980ba030058ab5a", "0", "0", 12]
# ]
# ## Crear UserDoctores
# puts "Creando Clientes"
# clientes_list.each do |_idGrupo, _idBanco, _idAlmacenRecepcion, grupo|
# 	cliente = Cliente.create(_idGrupo: _idGrupo, _idBanco: _idBanco, _idAlmacenRecepcion: _idAlmacenRecepcion, grupo: grupo)
# 	cliente.save!
# end	