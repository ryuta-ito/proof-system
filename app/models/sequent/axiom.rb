# axiom:
#   {Formula_1, ..., Formula_n}

require 'models/formula/formulasable'

class Sequent::Axiom
  attr_accessor :formulas
  include Formulasable
end
