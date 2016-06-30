class Bodega < ActiveRecord::Base
	has_many :almacenes, dependent: :destroy
	has_many :productos, through: :almacenes


def self.probando
	puts "Fecha: "<<Time.now.to_s
	puts "A esperar 5 segundos"
	sleep 5
	puts "Fecha: "<<Time.now.to_s
	puts "A esperar 10"
	sleep 10
	puts "Fecha: "<<Time.now.to_s
	puts "Sin Espera"
	puts "Fecha: "<<Time.now.to_s
end

def self.actualizarInfo
	puts "------ACTUALIZACIÓN------"
	puts "--- "<<Time.now.to_s<<" ---"
	#1. Actualizar Datos Bodega
	puts "Actualizando bodega"
	self.iniciarBodega(false)
 	#2. Graba la info del día
 	puts "Agregando información diaria"
  	self.agregarInfoDiaria
  	#3. Revisar FTP
  	puts "Revisando pedidos FTP"
  	ConsultarPedidosFtp.new.consultarOcsFTP
 	#4. Mandar a producir si hay bajo Stock
 	puts "Mandando a producir Stock"
  	ProducirMateriasPrimas.new.producirStockBajo
end

def self.iniciarBodega(desdeCero)
	ib = IniciarBodega.new('grupo7')
	if(desdeCero)
		return ib.iniciarBodega
	else
		return ib.actualizarBodega
	end
end

 def self.publish(tweet)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.config.twitter_key
      config.consumer_secret     = Rails.application.config.twitter_secret
      config.access_token        = Rails.application.config.access_token
      config.access_token_secret = Rails.application.config.access_token_secret
    end
      title = tweet[:message]
      url = tweet[:media]
      client.update_with_media(title, open(url))

      #Picking the graph api object from koala gem
    @graph = Koala::Facebook::API.new(Rails.application.config.facebook_access_token)
    @graph.put_wall_post(title, {
           link: url      #picture: image_url
       })
end

def self.agregarInfoDiaria
  #Agregar Saldo
  is= Infosaldo.where(fecha: Date.today.to_time(:utc))
  if (is.count==0)
    infosaldo = Infosaldo.create(fecha: Date.today, cantidad: Bodega.first.saldo)
    infosaldo.save!
  else
  	is= is.first
  	is.cantidad = Bodega.first.saldo
  	is.save!
  end

  #Agregar Stocks
  istock = Infostock.where(fecha: Date.today.to_time(:utc))
  if (istock.count==0)
    infostock1 = Infostock.create(sku: '1', fecha: Date.today, cantidadTotal: Bodega.checkStock('1'), cantidadDisponible: Bodega.checkStockTotal('1'))
    infostock1.save!
    infostock10 = Infostock.create(sku: '10', fecha: Date.today, cantidadTotal: Bodega.checkStock('10'), cantidadDisponible: Bodega.checkStockTotal('10'))
    infostock10.save!
    infostock23 = Infostock.create(sku: '23', fecha: Date.today, cantidadTotal: Bodega.checkStock('23'), cantidadDisponible: Bodega.checkStockTotal('23'))
    infostock23.save!
    infostock39 = Infostock.create(sku: '39', fecha: Date.today, cantidadTotal: Bodega.checkStock('39'), cantidadDisponible: Bodega.checkStockTotal('39'))
    infostock39.save!
else
	istock1 = Infostock.where(sku: '1', fecha: Date.today.to_time(:utc)).first
	istock1.cantidadTotal = Bodega.checkStock('1')
	istock1.cantidadDisponible = Bodega.checkStockTotal('1')
	istock1.save

	istock10 = Infostock.where(sku: '10', fecha: Date.today.to_time(:utc)).first
	istock10.cantidadTotal = Bodega.checkStock('10')
	istock10.cantidadDisponible = Bodega.checkStockTotal('10')
	istock10.save

	istock23 = Infostock.where(sku: '23', fecha: Date.today.to_time(:utc)).first
	istock23.cantidadTotal = Bodega.checkStock('23')
	istock23.cantidadDisponible = Bodega.checkStockTotal('23')
	istock23.save

	istock39 = Infostock.where(sku: '39', fecha: Date.today.to_time(:utc)).first
	istock39.cantidadTotal = Bodega.checkStock('39')
	istock39.cantidadDisponible = Bodega.checkStockTotal('39')
	istock39.save
  end
end




def self.checkStockTotal(sku)
	return checkStock(sku) - checkStockGuardado(sku)
end

def self.checkStock(sku)
	bodega= Bodega.first
	if bodega!=nil
		cantidad=0	
		almacenes = Bodega.first.almacenes
		almacenes.each do |almacen|
			stockPreguntado =almacen.stocks.find_by(sku: sku.to_s)
			if stockPreguntado!=nil
				cantidad= cantidad + stockPreguntado.total			
			end
		end
		return cantidad
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