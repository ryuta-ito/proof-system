# formula:
#   <atom> | <imply> | <conjunction> | <disjunction> | <existence>

class Formula
  class << self
    def multi_build(formulas_data)
      parse_formulas(formulas_data).map do |formula_data|
        build(formula_data)
      end
    end

    def build(formula_data)
      # priority order
      case formula_data
      when %r{=>}
        Imply.build(formula_data)
      when %r{∨}
        Disjunction.build(formula_data)
      when %r{∧}
        Conjunction.build(formula_data)
      when %r{∃|∀|¬}
        unary_class(formula_data).build(formula_data)
      else
        Atom.build(formula_data)
      end
    end

    private

    def parse_formulas(formulas_data)
      formulas_data.split(',').map do |formula_data|
        formula_data.strip
      end
    end

    def unary_class(formula_data)
      chars = formula_data.split('')
      [
        [chars.index('∃'), Existence],
        [chars.index('∀'), Existence],
        [chars.index('¬'), Existence]
      ].select do |index, _|
        index != nil
      end.min
    end
  end

  def free_variables
  end
end
