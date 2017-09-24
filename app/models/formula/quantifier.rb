class Formula::Quantifier < Formula
  attr_accessor :bounded_variable, :formula

  class << self
    def build(quantifier_data)
      new.tap do |quantifier|
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

  def free_variables
    formula.free_variables.select do |free_variable|
      !free_variable.identify?(bounded_variable)
    end
  end
end
