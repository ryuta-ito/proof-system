# consequece:
#   Formula_1, ..., Formula_n

require 'models/formula/formulasable'

class Sequent::Consequence
  attr_accessor :formulas
  include Formulasable
end
