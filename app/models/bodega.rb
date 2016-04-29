class Bodega < ActiveRecord::Base
	has_many :almacenes, dependent: :destroy
	has_many :productos, through: :almacenes


def self.cambiar
	b = Bodega.first
	b.cantAlmacenes= b.cantAlmacenes+1
	b.save
end
end
