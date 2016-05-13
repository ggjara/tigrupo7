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



# *** ----- DEVELOPMENT ***** -----
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