class Bodega < ActiveRecord::Base
	has_many :almacenes, dependent: :destroy
	has_many :productos, through: :almacenes
end
