class QueueRecibir < ApplicationController
require "bunny"
require "json"
require "date"

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
      inicio = Time.at(msg['inicio'])
      fin = Time.at(msg['fin'])
      codigo = msg['codigo']
      publicar = msg['publicar']

      puts sku
      puts precio
      puts inicio
      puts fin
      puts codigo
      puts publicar

      puts "Crear Promocion"
      #Crear promoción
      ap = AppPromotion.create(sku: sku.to_s, precio: precio.to_i, fechaInicio: inicio, fechaTermino: fin, codigo: codigo.to_s)
      #Crear publicación
      if(publicar)
        producto = ""
        url_imagen = ""
        if(ap.sku=='1')
          producto = "Pollo"
          url_imagen = "http://pollopepe.com.mx/wp-content/uploads/2013/07/01-pollo-entero1.jpg" 
        elsif (ap.sku=='10')
          producto = "Pan Marraqueta"
          url_imagen = "http://www.cl.all.biz/img/cl/catalog/37676.jpeg"
        elsif (ap.sku=='23')
          producto = "Harina"
          url_imagen = "http://2.bp.blogspot.com/-R_vACaZLlIU/VMEdsXeWeOI/AAAAAAAAAQk/oSbk3LTj3GA/s900/harina.PNG"
        elsif (ap.sku=='39')
          producto = "Uva"
          url_imagen = "http://difundir.org/wp-content/uploads/2015/04/hu2.jpg"
        end

        puts producto
        puts url_imagen
            
        mensajeAPublicar = "¡Nueva Promoción! - "<<producto<< " a sólo: $ "<<precio.to_s<<" - Entre las fechas: "<<ap.fechaInicio.day.to_s<<"/"<<ap.fechaInicio.month.to_s<<"/"<<ap.fechaInicio.year.to_s<<"-"<<ap.fechaTermino.day.to_s<<"/"<<ap.fechaTermino.month.to_s<<"/"<<ap.fechaTermino.year.to_s<<" CODIGO #"<<codigo.to_s<<"."
        puts mensajeAPublicar
        Bodega.publish({message: mensajeAPublicar, media: url_imagen})
      end

   

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
  ch = b.create_channel
  q = ch.queue("ofertas", :auto_delete => true) # declare a queue

  # declare default direct exchange which is bound to all queues
  e = ch.exchange("")

  paramsMsg = '{ "sku": 1,
    "precio": 10,
    "inicio": 1467158400,
    "fin": 1468972800,
    "codigo": 123,
    "publicar": true}'
  # publish a message to the exchange which then gets routed to the queue
  e.publish(paramsMsg, :key => 'ofertas')


  b.stop # close the connection
  return "sent"
end


end
