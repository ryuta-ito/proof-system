module Formulasable
  module ClassMethods
    def build(formulas_data)
      new( formulas: Formula.multi_build(formulas_data) )
    end
  end

  extend ClassMethods

  def self.included(klass)
    klass.include ActiveModel::Model
    klass.extend ClassMethods
  end

  def all_atom?
    formulas.all? { |formula| Atom === formula }
  end

  def substitute(target, replace)
    if Array === replace
      self.class.new( formulas: formulas.flat_map { |formula| formula.identify?(target) ? replace : formula } )
    else
      self.class.new( formulas: formulas.map { |formula| formula.identify?(target) ? replace : formula } )
    end
  end

  def add_formula(formula)
    self.class.new( formulas: formulas + [formula] )
  end

  def delete_formula(target_formula)
    self.class.new( formulas: formulas.select { |formula| !target_formula.identify?(formula) } )
  end

  def deductive_sequents(sequent)
    formula = formulas.find { |formula| !(Atom === formula) }
    formula ? formula.deductive_sequents(sequent, self) : []
  end

  def identify?(formulas_object)
    formulas.all? do |formula_a|
      formulas_object.formulas.any? do |formula_b|
        formula_a.identify? formula_b
      end
    end
  end

  def str
    "#{(formulas.map { |formula| ParenthesesParser.strip_edge_parentheses(formula.str) }).join(', ')}"
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
    self.class.new.tap do |diffed_axiom|
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
    self.class.new.tap do |diffed_axiom|
      diffed_axiom.formulas = multi_set_diff(formulas, axiom.formulas)
    end
  end

  def free_variables
    formulas.flat_map &:free_variables
  end

  def find; formulas.find { |formula| yield formula }; end

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
