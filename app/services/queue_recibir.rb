class QueueRecibir < ApplicationController
require "bunny"
require "json"

def initialize
end

def receive
  return threadReceive
end

#metodo que inicia un thread que queda suscrito a la cola, recibiendo mensajes y gatillando accion
def threadReceive
  #inicia conneccion con cola amqp
  conn = Bunny.new('amqp://eoddqask:UZDMkggws1re_EjcJet7iv8Sm56KiifC@jellyfish.rmq.cloudamqp.com/eoddqask')
  conn.start # start a communication session with the amqp server
  ch = conn.create_channel
  q = ch.queue("ofertas", :auto_delete => true) # declare a queue

  #inicia thread que quedara ecuchando mensajes
  t1 = Thread.new do
    begin
    puts " [*] Waiting for messages. To exit press CTRL+C"
    q.subscribe(:block => true) do |delivery_info, properties, body|

      #Aca debe gatillar posteo en fb y tweeters
      msg = JSON.parse(body)

      sku = msg['sku']
      precio = msg['precio']
      inicio = msg['inicio']
      fin = msg['fin']
      codigo = msg['codigo']
      publicar = msg['publicar']

      #Crear promoción
      AppPromotion.create(sku: sku.to_s, precio: precio.to_i, fechaInicio: inicio, fechaTermino: fin, codigo: codigo.to_s)

      #Crear publicación
      if(publicar)
        producto = ""
        url_imagen = ""
        if(sku=='1')
          producto = "Pollo"
          url_imagen = "http://pollopepe.com.mx/wp-content/uploads/2013/07/01-pollo-entero1.jpg" 
        elsif (sku=='10')
          producto = "Pan Marraqueta"
          url_imagen = "http://www.cl.all.biz/img/cl/catalog/37676.jpeg"
        elsif (sku=='23')
          producto = "Harina"
          url_imagen = "http://2.bp.blogspot.com/-R_vACaZLlIU/VMEdsXeWeOI/AAAAAAAAAQk/oSbk3LTj3GA/s900/harina.PNG"
        elsif (sku=='39')
          producto = "Uva"
          url_imagen = "http://difundir.org/wp-content/uploads/2015/04/hu2.jpg"
        end
            
        mensajeAPublicar = "¡Nueva Promoción! - "+producto+ " a sólo: $ "+precio+" - Entre las fechas: "+inicio+"/"+fin+" - CODIGO #"+codigo
        Bodega.publish({message: mensajeAPublicar, media: url_imagen})
      end



      puts sku
      puts precio
      puts inicio
      puts fin
      puts codigo
      puts publicar


    end
    rescue Interrupt => _
      conn.close

      exit(0)
    end

  end
  return "running"
end

#metodo que recibe mensaje un mensaje cada vez que se llama
def webHookReceive
  conn = Bunny.new('amqp://eoddqask:UZDMkggws1re_EjcJet7iv8Sm56KiifC@jellyfish.rmq.cloudamqp.com/eoddqaskcd')
  conn.start # start a communication session with the amqp server
  ch = conn.create_channel
  q = ch.queue("ofertas", :auto_delete => true) # declare a queue

  delivery_info, properties, payload = q.pop
  msg = payload
  puts msg
  conn.close
  return msg
end


#metodo para hacer pruebas
def send

  b = Bunny.new('amqp://eoddqask:UZDMkggws1re_EjcJet7iv8Sm56KiifC@jellyfish.rmq.cloudamqp.com/eoddqask')
  b.start # start a communication session with the amqp server
  puts existe
  ch = b.create_channel
  q = ch.queue("ofertas", :auto_delete => true) # declare a queue

  # declare default direct exchange which is bound to all queues
  e = ch.exchange("")

  paramsMsg = '{ "sku": 1,
    "precio": 10,
    "inicio": 35646513,
    "fin": 54652318648,
    "codigo": 123,
    "publicar": true}'
  # publish a message to the exchange which then gets routed to the queue
  e.publish(paramsMsg, :key => 'ofertas')


  b.stop # close the connection
  return "sent"
end


end
