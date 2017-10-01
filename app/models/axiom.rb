# axiom:
#   {Formula_1, ..., Formula_n}

class Axiom
  attr_accessor :str, :formulas

  class << self
    def build(axiom_data)
      new.tap do |axiom|
        axiom.str = axiom_data
        axiom.formulas = Formula.multi_build(parse_axiom axiom_data)
      end
    end

    private

    def parse_axiom(axiom_data)
      axiom_data.delete('{|}').strip
    end
  end

  def show
    puts str
  end

  def identify?(axiom)
    return false unless self.class === axiom

    formulas.map do |formula_a|
      axiom.formulas.map do |formula_b|
        formula_a.identify? formula_b
      end.any?
    end.all?
  end

  def xor_diff(axiom)
    Axiom.new.tap do |diffed_axiom|
      diff_a = axiom.formulas.select do |given_formula|
        formulas.all? { |self_formula| !self_formula.identify?(given_formula) }
      end
      diff_b = formulas.select do |self_formula|
        axiom.formulas.all? { |given_formula| !given_formula.identify?(self_formula) }
      end
      diffed_axiom.formulas = diff_a + diff_b
    end
  end

  def diff(axiom)
    Axiom.new.tap do |diffed_axiom|
      diffed_axiom.formulas = multi_set_diff(formulas, axiom.formulas)
    end
  end

  def free_variables
    formulas.flat_map &:free_variables
  end

  private

  def multi_set_diff(formulas_a, formulas_b)
    return [] if formulas_a.empty?
    index = formulas_b.find_index { |formula_b| formulas_a.first.identify?(formula_b) }

    if index
      multi_set_diff(formulas_a.drop(1), formulas_b.select.with_index { |_, i| i != index } )
    else
      [formulas_a.first] + multi_set_diff(formulas_a.drop(1), formulas_b)
    end
  end
end
