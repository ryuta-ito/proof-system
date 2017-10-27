# consequece:
#   Formula_1, ..., Formula_n

require 'models/sequent/deductible'

class Sequent::Consequence
  attr_accessor :formulas
  include Deductible

  def side
    'R'
  end

  def alpha_signs
    [Disjunction, Negation, Imply]
  end

  def beta_signs
    [Sequent::Consequence]
  end

  def gamma_sign
    Existence
  end

  def delta_sign
    Universal
  end
end
