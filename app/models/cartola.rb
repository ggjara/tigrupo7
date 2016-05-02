class Cartola < ActiveRecord::Base
  belongs_to :cuenta
  has_many :transaccions
end
