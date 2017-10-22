# formula:
#   <atom> | <imply> | <conjunction> | <disjunction> | <existence> | <universal> | (<formula>)

class Formula
  class << self
    def multi_build(formulas_data)
      parse_formulas(formulas_data).map do |formula_data|
        build(formula_data)
      end
    end

    def build(formula_data)
      left_data, right_data, operation_code = FormulaParser.divide_most_low_priority_operation(formula_data)
      case operation_code
      when :imply
        Imply.build(left_data, right_data)
      when :disjunction
        Disjunction.build(left_data, right_data)
      when :conjunction
        Conjunction.build(left_data, right_data)
      when :atom
        Atom.build(left_data)
      else
        raise "#{operation_code} ??????"
      end
    end

    def operation
      {
        imply: Imply.code,
        disjunction: Disjunction.code,
        conjunction: Conjunction.code
      }
    end

    def priority
      operation.each.with_index.with_object({}) do |((name, _), index), priority_hash|
        priority_hash[name] = index
      end
    end

    def priority_by_data(op_data)
      operation_key = Formula.operation.invert[op_data]
      Formula.priority[operation_key]
    end

    def operation_reg_exp
      %r{^(?<operation>#{operation.values.join('|')})}
    end

    def operation_chars
      operation.merge({imply: '='}).values
    end

    private

    def parse_formulas(formulas_data)
      formulas_data.split(',').map do |formula_data|
        formula_data.strip
      end
    end
  end

  def code
    self.class.code
  end

  def show
    puts str
  end

  def deductive_sequents_axiom(sequent)
    raise NotImplementedError
  end

  def deductive_sequents_axiom(sequent)
    raise NotImplementedError
  end

  def deductive_sequents(sequent, sign)
    case sign
    when Sequent::Consequence
      deductive_sequents_consequece(sequent)
    when Sequent::Axiom
      deductive_sequents_axiom(sequent)
    end
  end
end
