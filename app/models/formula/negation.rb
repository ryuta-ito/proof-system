# negation:
#   ¬<formula>

class Negation < Formula
  attr_accessor :formula

  include ActiveModel::Model

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

  def free_variables
    formula.free_variables
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
end
