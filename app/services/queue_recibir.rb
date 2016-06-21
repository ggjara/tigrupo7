class QueueRecibir < ApplicationController
require "bunny"

def initialize
end

def receive
  conn = Bunny.new('amqp://eoddqask:UZDMkggws1re_EjcJet7iv8Sm56KiifC@jellyfish.rmq.cloudamqp.com/eoddqask')
  conn.start # start a communication session with the amqp server
  ch = conn.create_channel
  q = ch.queue("ofertas", :durable => true) # declare a queue

  msg = ""
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
    msg = body
    # cancel the consumer to exit
    delivery_info.consumer.cancel
  end
  # paramsMsg = { sku: msg['sku'],
  #   precio: msg['precio'],
  #   inicio: msg['inicio'],
  #   fin: msg['fin'],
  #   codigo: msg['codigo'],
  #   publicar: msg['publicar']}

  return msg
end

def send

  b = Bunny.new('amqp://eoddqask:UZDMkggws1re_EjcJet7iv8Sm56KiifC@jellyfish.rmq.cloudamqp.com/eoddqask')
  b.start # start a communication session with the amqp server
  existe = b.queue_exists?("ofertas")
  puts existe
  ch = b.create_channel
  q = ch.queue("ofertas", :durable => true) # declare a queue

  # declare default direct exchange which is bound to all queues
  e = ch.exchange("")

  paramsMsg = '{ sku: "1",
    precio: "10",
    inicio: "1/1/1",
    fin: "2/1/1",
    codigo: "123",
    publicar: "true"}'
  # publish a message to the exchange which then gets routed to the queue
  e.publish(paramsMsg, :key => 'ofertas')


  b.stop # close the connection
  return existe
end


end
