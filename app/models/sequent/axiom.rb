# axiom:
#   {Formula_1, ..., Formula_n}

require 'models/sequent/deductible'

class Sequent::Assumption
  attr_accessor :formulas
  include Deductible

  def side
    'L'
  end

  def alpha_signs
    [Conjunction, Negation]
  end

  def beta_signs
    [Disjunction, Imply]
  end

  def gamma_sign
    Universal
  end

  def delta_sign
    Existence
  end
end
