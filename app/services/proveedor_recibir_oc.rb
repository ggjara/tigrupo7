class ProveedorRecibirOc < ApplicationController

# Orden:
# 1: Se crea la OC en la db
# 2: Se verifica si se acepta o no
# 3.1: Si se acepta, se acepta en server y db (Estado de la OC propio y también el que viene)
# 3.2: Si no se acepta, se rechaza en server y db (Estado de la OC que viene)
# 4.1: Si se acepta, se envía respueta de aceptación al cliente
# 4.2 Si no se acepta, se envía respuesta de cancelación al cliente


def initialize
end

#Retorna arreglo con respuesta
#respuesta: true/false si se aceptó o no la OC y oc_id: id de la orden de compra consultada
def responderOc(oc_id)
	respuesta = false
	ocGenerada = hacerOcDB(oc_id) #Creamos una OC o verificamos si ya existe
	if(ocGenerada!=false) # Si ya existe, entonces no la aceptamos
		puts "---OC GENERADA---"
		if verificarAceptarOc(ocGenerada) #Verificamos si la podemos aceptar
			puts "---PARAMS OC CORRECTOS---"
			if(aceptarOcServerDB(ocGenerada)) #Si la podemos aceptar. La aceptamos en server y DB
				puts "---OC GUARDADA EN SERVIDOR---"

				puts "++++++++++++++++++"
				puts ocGenerada._id
				puts ocGenerada.estado
				puts "++++++++++++++++++"

				respuesta= true
			else
				rechazarOcServerDB(ocGenerada,'NoSePudoAceptarProblemaServidor')
				respuesta= false
			end
		else
			rechazarOcServerDB(ocGenerada, 'NoCumpleRequisitos')
			respuesta= false
		end
	else
		rechazarOcServerDBById(oc_id,'YaFueCreadaEstaSolicitud')
		respuesta= false
	end

	return respuesta
end

#Returna una instancia del modelo OC creado
#Retorna False si ya recibimos OC anteriormente
def hacerOcDB(oc_id)
	if (Oc.find_by(_id: oc_id) != nil)
		puts "xxxYA EXIXTExxx"
		return false
	else
		request= RequestsOc.new
		paramsOc = request.obtenerOc(oc_id)
		if(paramsOc==false)
			return false
		end
		ocGenerada = Oc.new(paramsOc)
		ocGenerada.save
		return ocGenerada
	end

end


#Retorna true or false si pasa los filtros para saber si aceptamos o no la OC
#Verifica Pertinencia de la OC (Son productos de nosotros?)
#Verifica Stock (actual)
#Verifica Precio (Corresponde al precio que está fijado?)
#Verifica duplicados
def verificarAceptarOc(oc)
	if(oc.proveedor!=Cliente.find_by(grupo: 7)[:_idGrupo])
		puts "xxxPROVEEDOR INCORRECTOxxx"
		return false
	end
	if ( (oc.sku !='1') && (oc.sku !='10') && (oc.sku. != '23') && (oc.sku.!= '39'))
		puts "xxxSKU INCORRECTOxxx"
		return false
	end

	if (oc.precioUnitario < precioDeSku(oc.sku))
		puts "xxxPRECIO INCORRECTOxxx"
		return false
	end

	if(!verificarStock(oc.sku, oc.cantidad))
		puts "xxxSTOCK INCORRECTOxxx"
			return false
 end
	return true
end

def aceptarOcServerDB(oc)
	estadoServidor = RequestsOc.new.recepcionarOc(oc._id)
	if(estadoServidor!=false)
		oc.estado= estadoServidor[:estado]
		oc.save
		Bodega.guardarStock(oc.sku, oc.cantidad.to_i)
		puts "++++++++++++++++++"
		puts estadoServidor[:_id]
		puts estadoServidor[:estado]
		puts "++++++++++++++++++"
		return true
	else
		puts "xxxNO SE PUEDE RECEPCIONARxxx"
		return false
	end
end

def rechazarOcServerDB(oc,rechazo)
	estadoServidor = RequestsOc.new.rechazarOc(oc._id,rechazo)
	if(estadoServidor!=false)
		oc.estado= estadoServidor[:estado]
		oc.estadoDB= 'rechazada'
		oc.save
		puts "xxxRECHAZADAxxx"
		return true
	else
		return false
	end
end

def rechazarOcServerDBById(oc_id,rechazo)
	oc = Oc.find_by(_id: oc_id)
	if(oc == nil)
		return false
	end
	estadoServidor = RequestsOc.new.rechazarOc(oc._id,rechazo)
	if(estadoServidor!=false)
		oc.estado= estadoServidor[:estado]
		oc.estadoDB= 'rechazada'
		oc.save
		puts "xxxRECHAZADAxxx"
		return true
	else
		return false
	end
end


def precioDeSku(sku)
	if sku=='1' || sku==1
		return 	Prize.find_by(sku: '1').prize
	elsif sku=='10' || sku==10
		return  Prize.find_by(sku: '10').prize 
	elsif sku=='23'|| sku==23
		return 	Prize.find_by(sku: '23').prize
	elsif sku=='39'|| sku==39
		return 	Prize.find_by(sku: '39').prize
	end
end

def verificarStock(sku, cantidad)
	stockActual =   Bodega.checkStock(sku)
	stockGuardado = Bodega.checkStockGuardado(sku)
	if cantidad > (stockActual - stockGuardado)
		return false
	else
		return true
	end
end





end
