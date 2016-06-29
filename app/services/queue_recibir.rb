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
