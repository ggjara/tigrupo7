class Cuenta < ActiveRecord::Base
  has_one :saldo
  has_one :cartola
  has_many :transaccions, through: :cartola
end
