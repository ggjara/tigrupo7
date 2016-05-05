class ProveedorRecibirOcFtp < ApplicationController

# Orden:
# 1: Se verifica si se acepta o no
# 2.1: Si se acepta, se acepta en server y db (Estado de la OC propio y también el que viene)
# 2.2: Si no se acepta, se rechaza en server y db (Estado de la OC que viene)

def initialize
end

#Retorna arreglo con respuesta
#respuesta: true/false si se aceptó o no la OC y oc_id: id de la orden de compra consultada
def responderOc(oc)
	respuesta = false
	if verificarAceptarOc(oc) #Verificamos si la podemos aceptar
		if(aceptarOcServerDB(oc)) #Si la podemos aceptar. La aceptamos en server y DB
			respuesta = true
		else
			rechazarOcServerDB(oc,'NoSePudoAceptarProblemaServidor')
			respuesta = false
		end
	else
		rechazarOcServerDB(oc, 'NoCumpleRequisitos')
		respuesta = false
	end

	return respuesta
end


#Retorna true or false si pasa los filtros para saber si aceptamos o no la OC
#Verifica Pertinencia de la OC (Son productos de nosotros?)
#Verifica Stock (actual)
#Verifica Precio (Corresponde al precio que está fijado?)
#Verifica duplicados
def verificarAceptarOc(oc)
	puts'----VERIFICANDO-----'
	if(oc.proveedor!=Cliente.find_by(grupo: 7)._idGrupo)
		puts'XXXX Rechazo XXXX PERTENENCIA'
		return false
	end
	if ( (oc.sku !='1') && (oc.sku !='10') && (oc.sku. != '23') && (oc.sku.!= '39'))
		puts'XXXX Rechazo XXXX SKU'
		return false
	end

	if (oc.precioUnitario < precioDeSku(oc.sku))
		puts'XXXX Rechazo XXXX PRECIO'
	 	return false
	end

	if(!verificarStock(oc.sku, oc.cantidad))
		puts'XXXX Rechazo XXXX STOCK'
	   	return false
	end

	return true
end

def aceptarOcServerDB(oc)
	puts'----ACEPTAR EN SERVER-----'
	estadoServidor = RequestsOc.new.recepcionarOc(oc._id)
	if(estadoServidor!=false)
		oc.estado= estadoServidor[:estado]
		oc.estadoDB = 'aceptada'
		oc.save
		Bodega.guardarStock(oc.sku, oc.cantidad.to_i)
		return true
	else
		puts'----ERROR EN SERVER-----'
		return false
	end
end

def rechazarOcServerDB(oc,rechazo)
	puts'----RECHAZAR EN SERVER-----'
	estadoServidor = RequestsOc.new.rechazarOc(oc._id,rechazo)
	if(estadoServidor!=false)
		oc.estado= estadoServidor[:estado]
		oc.estadoDB= 'rechazada'
		oc.save
		return true
	else
		puts'----ERROR EN SERVER-----'
		return false
	end
end
		

def precioDeSku(sku)
	if sku=='1' || sku==1
		return 1159
	elsif sku=='10' || sku==10
		return  15718 
	elsif sku=='23'|| sku==23
		return 4294
	elsif sku=='39'|| sku==39
		return 1217
	end
end

def verificarStock(sku, cantidad)
	if cantidad > Bodega.checkStockTotal(sku)
		return false
	else
		return true
	end
end

end


