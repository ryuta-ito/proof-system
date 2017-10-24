# negation:
#   ¬<formula>

require 'forwardable'

class Negation < Formula
  attr_accessor :formula

  include ActiveModel::Model

  extend Forwardable
  def_delegators :@formula, :free_variables, :constants

  class << self
    def build(negation_data)
      new( formula: Formula.build(parse_negation negation_data) )
    end

    def code
      '¬'
    end

    private

    def parse_negation(negation_data)
      negation_data.sub(%r{\w*#{code}}, '')
    end
  end

  def str
    "#{self.class.code}#{formula.str}"
  end

  def identify?(target_formula)
    self.class === target_formula && target_formula.formula.identify?(formula)
  end

  def substitute(target, replace)
    return replace if identify?(target)
    return self unless self.class === target

    new.tap do |negation|
      negation.formula = formula.substitute(target, replace)
    end
  end

  def unify(target_formula)
    (self.class === target_formula) ? formula.unify(target_formula) : NonUnifier.build
  end

  def deductive_sequents_consequece(sequent)
    [ Sequent.new( axiom: sequent.axiom.add_formula(formula), consequece: sequent.consequece.delete_formula(self) ) ]
  end

  def deductive_sequents_axiom(sequent)
    [ Sequent.new( axiom: sequent.axiom.delete_formula(self), consequece: sequent.consequece.add_formula(formula) ) ]
  end
end
