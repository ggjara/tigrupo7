class QueueRecibir < ApplicationController
require "bunny"

def initialize
end

def receive
  conn = Bunny.new ENV['amqp://eoddqask:UZDMkggws1re_EjcJet7iv8Sm56KiifC@jellyfish.rmq.cloudamqp.com/eoddqask']
  conn.start # start a communication session with the amqp server

  q = conn.queue("ofertas") # declare a queue

  # declare default direct exchange which is bound to all queues

  msg = q.pop[:payload] # get message from the queue

  paramsMsg = { sku: msg['sku'],
    precio: msg['precio'],
    inicio: msg['inicio'],
    fin: msg['fin'],
    codigo: msg['codigo'],
    publicar: msg['publicar']}

  conn.stop # close the connection

  return paramsMsg
end

def send

  b = Bunny.new ENV['amqp://eoddqask:UZDMkggws1re_EjcJet7iv8Sm56KiifC@jellyfish.rmq.cloudamqp.com/eoddqask']
  b.start # start a communication session with the amqp server

  q = b.queue("ofertas") # declare a queue

  # declare default direct exchange which is bound to all queues
  e = b.exchange("")

  # publish a message to the exchange which then gets routed to the queue
  e.publish("Hello, everybody!", :key => 'ofertas')


  b.stop # close the connection
  return "publicado"
end


end
