class Bodega < ActiveRecord::Base
	has_many :almacenes, dependent: :destroy
	has_many :productos, through: :almacenes


def self.iniciarBodega
	ib = IniciarBodega.new('grupo7')
	return ib.iniciarBodega
end

def self.cambiar
	b = Bodega.first
	b.cantAlmacenes= b.cantAlmacenes+1
	b.save
end
end
