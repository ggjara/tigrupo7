class Bodega < ActiveRecord::Base
	has_many :almacenes, dependent: :destroy
	has_many :productos, through: :almacenes


def self.iniciarBodega(desdeCero)
	ib = IniciarBodega.new('grupo7')
	if(desdeCero)
		return ib.iniciarBodega
	else
		return ib.actualizarBodega
	end
end

def self.cambiar
	if Bodega.first!=nil
		b = Bodega.first
		b.cantAlmacenes= b.cantAlmacenes+1
		b.save
	end
end

def self.checkStock(sku)
	cant=Producto.all.where(sku: sku).count 
	if(cant!=nil)
		return cant
	else 
		return 0
	end
end

def self.checkStockGuardado(sku)
	if Bodega.first!=nil
		bodegaGrupo7 = Bodega.first
		if sku=='1' || sku== 1
			return bodegaGrupo7.stockGuardadoSku1
		elsif sku=='10'|| sku== 10
			return bodegaGrupo7.stockGuardadoSku10
		elsif sku=='23'|| sku== 23
			return bodegaGrupo7.stockGuardadoSku23
		elsif sku=='39'|| sku== 39
			return bodegaGrupo7.stockGuardadoSku39
		else
			return 0
		end
	else
		return 0
	end
end

def self.guardarStock(sku, cantidad)
	if Bodega.first!=nil
		bodegaGrupo7 = Bodega.first
		if sku=='1' || sku== 1
			bodegaGrupo7.stockGuardadoSku1 += cantidad
		elsif sku=='10'|| sku== 10
			bodegaGrupo7.stockGuardadoSku10 += cantidad
		elsif sku=='23'|| sku== 23
			bodegaGrupo7.stockGuardadoSku23 += cantidad
		elsif sku=='39'|| sku== 39
			bodegaGrupo7.stockGuardadoSku39 += cantidad
		end
		bodegaGrupo7.save
	end	
end

def self.eliminarStockGuardado(sku,cantidad)
	if(Bodega.first!=nil)
		bodegaGrupo7 = Bodega.first
		if sku=='1' || sku== 1
			bodegaGrupo7.stockGuardadoSku1 = bodegaGrupo7.stockGuardadoSku1 - cantidad
			if bodegaGrupo7.stockGuardadoSku1<0
				bodegaGrupo7.stockGuardadoSku1=0
			end
		elsif sku=='10' || sku== 10
			bodegaGrupo7.stockGuardadoSku10 = bodegaGrupo7.stockGuardadoSku10 - cantidad
			if bodegaGrupo7.stockGuardadoSku10<0
				bodegaGrupo7.stockGuardadoSku10=0
			end
		elsif sku=='23' || sku== 23
			bodegaGrupo7.stockGuardadoSku23 = bodegaGrupo7.stockGuardadoSku23 - cantidad
			if bodegaGrupo7.stockGuardadoSku23<0
				bodegaGrupo7.stockGuardadoSku23=0
			end
		elsif sku=='39' || sku== 39
			bodegaGrupo7.stockGuardadoSku39 = bodegaGrupo7.stockGuardadoSku39 - cantidad
			if bodegaGrupo7.stockGuardadoSku39<0
				bodegaGrupo7.stockGuardadoSku39=0
			end
		end
		bodegaGrupo7.save
	end
end

def self.restarSaldo(cantidad)
	bodegaGrupo7 = Bodega.first
	if(bodegaGrupo7!=nil)
		bodegaGrupo7.saldo = bodegaGrupo7.saldo - cantidad
		bodegaGrupo7.save
	end
end

def self.sumarSaldo(cantidad)
	bodegaGrupo7 = Bodega.first
	if(bodegaGrupo7!=nil)
		bodegaGrupo7.saldo = bodegaGrupo7.saldo + cantidad
		bodegaGrupo7.save
	end
end

end