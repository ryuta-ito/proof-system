class Formula::Quantifier < Formula
  attr_accessor :bounded_variable, :formula

  class << self
    def build(quantifier_data)
      new.tap do |qantifier|
        qantifier.bounded_variable = Variable.build(parse_qantifier(qantifier_data)[0])
        qantifier.formula = Formula.build(parse_qantifier(qantifier_data)[1])
      end
    end

    def code
      raise NotImplementedError
    end

    private

    def parse_qantifier(qantifier_data)
      qantifier_data.split(/#{code}|\./).drop(1).map do |data|
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
