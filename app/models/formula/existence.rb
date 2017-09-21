# existence:
#   ∃<bounded_variable>.<formula>

class Existence < Formula
  attr_accessor :bounded_variable, :formula

  class << self
    def build(existence_data)
      new.tap do |existence|
        existence.bounded_variable = parse_existence(existence_data)[0]
        existence.formula = Formula.build(parse_existence(existence_data)[1])
      end
    end

    private

    def parse_existence(existence_data)
      existence_data.split(/∃|\./).drop(1).map do |data|
        data.strip
      end
    end
  end
end
