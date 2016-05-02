# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160502211815) do

  create_table "almacenes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "_id"
    t.integer  "grupo"
    t.boolean  "pulmon"
    t.boolean  "despacho"
    t.boolean  "recepcion"
    t.integer  "totalSpace"
    t.integer  "usedSpace"
    t.integer  "bodega_id"
  end

  create_table "bodegas", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "name"
    t.integer  "cantAlmacenes"
    t.integer  "cantProductos"
    t.integer  "stockGuardadoSku1",  default: 0
    t.integer  "stockGuardadoSku10", default: 0
    t.integer  "stockGuardadoSku23", default: 0
    t.integer  "stockGuardadoSku39", default: 0
  end

  create_table "facturas", force: :cascade do |t|
    t.string   "_id"
    t.string   "proveedor"
    t.string   "cliente"
    t.integer  "valorBruto"
    t.integer  "iva"
    t.integer  "valorTotal"
    t.string   "estadoPago"
    t.string   "id_Oc"
    t.string   "motivoRechazo"
    t.string   "motivoAnulacion"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "ocs", force: :cascade do |t|
    t.string   "_id"
    t.string   "cliente"
    t.string   "proveedor"
    t.string   "sku"
    t.integer  "cantidad"
    t.integer  "cantidadDespachada"
    t.integer  "precioUnitario"
    t.string   "canal"
    t.string   "estado"
    t.string   "idFactura"
    t.datetime "fechaEntrega"
    t.string   "fechaCreacion"
    t.string   "notas"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "trxDB"
    t.string   "facturaDB"
    t.boolean  "facturaRealizadaDB",  default: false
    t.boolean  "trxRealizadaDB",      default: false
    t.boolean  "despachoRealizadoDB", default: false
    t.string   "estadoDB",            default: ""
  end

  create_table "params", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pizzas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "productos", force: :cascade do |t|
    t.string   "_id"
    t.integer  "grupo"
    t.string   "almacen"
    t.string   "sku"
    t.string   "direccion"
    t.float    "precio"
    t.float    "costo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "almacen_id"
    t.boolean  "despachado"
  end

  create_table "trxes", force: :cascade do |t|
    t.string   "_id"
    t.string   "cuentaOrigen"
    t.string   "cuentaDestino"
    t.float    "monto"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
