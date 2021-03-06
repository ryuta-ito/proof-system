class Formula::Quantifier < Formula
  attr_accessor :code, :bounded_variable, :formula

  include ActiveModel::Model

  class << self
    def build(quantifier_data)
      new( code: code,
           bounded_variable: Variable.build(parse_quantifier(quantifier_data)[0]),
           formula: Formula.build(parse_quantifier(quantifier_data)[1]) )
    end

    def code
      raise NotImplementedError
    end

    private

    def parse_quantifier(quantifier_data)
      quantifier_data.sub(/^\s*#{code}/, '').split('.', 2).map do |data|
        ParenthesesParser.strip_edge_parentheses data.strip
      end
    end
  end

  def str
    "#{code}#{bounded_variable.str}.#{formula.str}"
  end

  def identify?(quantifier)
    return false unless self.class === quantifier

    bounded_variable.identify?(quantifier.bounded_variable) &&
      formula.identify?(quantifier.formula)
  end

  def free_variables
    formula.free_variables.select do |free_variable|
      !free_variable.identify?(bounded_variable)
    end
  end

  def constants
    formula.constants
  end

  def substitute(target, replace)
    if replace.free_variables.any? { |free_variable| free_variable.identify?(bounded_variable) }
      raise ReplaceDataBounded
    end

    return self if target.identify?(bounded_variable)

    self.clone.tap do |quantifier|
      quantifier.bounded_variable = bounded_variable
      quantifier.formula = formula.substitute(target, replace)
    end
  end

  def unify(target_formula)
    return NonUnifier.build unless self.class === target_formula

    unifier = formula.unify(target_formula.formula)

    if unifier.variable_include?(bounded_variable)
      raise NotImplementedError
    else
      unifier
    end
  end

  class ReplaceDataBounded < StandardError; end
end
