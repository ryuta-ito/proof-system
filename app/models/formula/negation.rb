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

  def deductive_sequents_consequence(sequent)
    [ Sequent.new( assumption: sequent.assumption.add_formula(formula), consequence: sequent.consequence.delete_formula(self) ) ]
  end

  def deductive_sequents_assumption(sequent)
    [ Sequent.new( assumption: sequent.assumption.delete_formula(self), consequence: sequent.consequence.add_formula(formula) ) ]
  end

  def expantion_tableux_consequence
    Tableaux::Series.new( tableaux: [ Tableau::Assumption.new( formula: formula ) ])
  end

  def expantion_tableux_assumption
    Tableaux::Series.new( tableaux: [ Tableau::Consequence.new( formula: formula ) ])
  end

  def disjunctive_normal
    normal :disjunctive_normal
  end

  def conjunctive_normal
    normal :conjunctive_normal
  end

  private

  def normal(method)
    case formula
    when Atom
      self
    when Imply
      (Negation.new formula: formula.send(method)).send(method)
    when Negation
      formula.formula.send(method)
    when Conjunction
      Disjunction.new left: (Negation.new formula: formula.left).send(method),
                      right: (Negation.new formula: formula.right).send(method)
    when Disjunction
      Conjunction.new(left: (Negation.new formula: formula.left).send(method),
                      right: (Negation.new formula: formula.right).send(method)).send(method)
    else
      raise 'unexpected'
    end
  end
end
