module Formulasable
  module ClassMethods
    def build(formulas_data)
      new( formulas: Formula.multi_build(formulas_data) )
    end

    def build_empty
      new( formulas: [] )
    end
  end

  extend ClassMethods

  def self.included(klass)
    klass.include ActiveModel::Model
    klass.extend ClassMethods
    klass.extend Forwardable
    klass.def_delegator :formulas, :size
  end

  def identify?(formulas_object)
    judge = -> (formulas_a, formulas_b) do
      formulas_a.all? do |formula_a|
        formulas_b.any? do |formula_b|
          formula_a.identify? formula_b
        end
      end && !formulas_a.empty?
    end
    judge.(formulas, formulas_object.formulas) && judge.(formulas_object.formulas, formulas)
  end

  def str
    "#{(formulas.map { |formula| ParenthesesParser.strip_edge_parentheses(formula.str) }).join(', ')}"
  end

  def show
    puts str
  end

  def xor_diff(assumption)
    self.class.new.tap do |diffed_assumption|
      diff_a = assumption.formulas.select do |given_formula|
        formulas.all? { |self_formula| !self_formula.identify?(given_formula) }
      end
      diff_b = formulas.select do |self_formula|
        assumption.formulas.all? { |given_formula| !given_formula.identify?(self_formula) }
      end
      diffed_assumption.formulas = diff_a + diff_b
    end
  end

  def diff(assumption)
    self.class.new.tap do |diffed_assumption|
      diffed_assumption.formulas = multi_set_diff(formulas, assumption.formulas)
    end
  end

  def free_variables
    formulas.flat_map &:free_variables
  end

  def constants
    formulas.flat_map &:constants
  end

  def find; formulas.find { |formula| yield formula }; end

  def one_formula
    formulas.empty? ? nil : formulas.first
  end

  def uniq
    _uniq formulas
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

  def _uniq(formulas_a, formulas_b = [])
    formula_head = formulas_a.first
    if formula_head
      _uniq (formulas_a.drop(1).reject { |formula| formula.identify?(formula_head) }),
            (formulas_b + [formula_head])
    else
      self.class.new formulas: formulas_b
    end
  end
end
