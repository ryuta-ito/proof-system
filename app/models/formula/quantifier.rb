class Formula::Quantifier < Formula
  attr_accessor :code, :bounded_variable, :formula

  class << self
    def build(quantifier_data)
      new.tap do |quantifier|
        quantifier.code = code
        quantifier.bounded_variable = Variable.build(parse_quantifier(quantifier_data)[0])
        quantifier.formula = Formula.build(parse_quantifier(quantifier_data)[1])
      end
    end

    def code
      raise NotImplementedError
    end

    private

    def parse_quantifier(quantifier_data)
      quantifier_data.split(/#{code}|\./).drop(1).map do |data|
        data.strip
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

  class ReplaceDataBounded < StandardError; end
end
