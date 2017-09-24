# existence:
#   ∀<bounded_variable>.<formula>

class Universal < Formula
  attr_accessor :bounded_variable, :formula

  class << self
    def build(universal_data)
      new.tap do |universal|
        universal.bounded_variable = parse_univarsal(universal_data)[0]
        universal.formula = Formula.build(parse_univarsal(universal_data)[1])
      end
    end

    private

    def parse_univarsal(universal_data)
      universal_data.split(/∀|\./).drop(1).map do |data|
        data.strip
      end
    end
  end

  def free_variables
    formula.free_variables.select { |free_variable| !free_variable.identify?(bounded_variable) }
  end
end
