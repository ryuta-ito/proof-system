# (A => B) ∨ C ∧ B =divide=> ['A => B', '∨ C ∧ B']
# (A => B) ∨ C ∧ B =split=> ['A => B', '∨', 'C', '∧', 'B']

require 'parsers/parser_base'
require 'parsers/state_base'

module FormulaParser
  extend ParserBase

  class << self
    def split_divide(data)
      disjunction_divide([ParenthesesParser, OperationParser], data)
    end

    def divide_most_low_priority_operation(data)
      splited_data = split(ParenthesesParser.strip_edge_parentheses data)
      return [splited_data.join, '', :atom] if splited_data.size == 1

      op_data = most_low_priority_operation(splited_data)
      middle_index = splited_data.index(op_data)
      [ splited_data[0..(middle_index-1)].join, splited_data[(middle_index+1)..(-1)].join, Formula.operation.invert[op_data] ]
    end

    private

    def start_state
      Start.new
    end

    def most_low_priority_operation(splited_data)
      _, op_data = splited_data.map(&:strip).select do |data|
        data.match Formula.operation_reg_exp
      end.map do |op_data|
        [Formula.priority_by_data(op_data), op_data]
      end.min
      op_data
    end
  end

  class Start < StateBase
    def next_state(input)
      case [input, top]
      when ['(', nil]
        ParenthesesParser::SemiBalance.new([input])
      when *refused_match
        StateBase::Refused.new
      when [input, nil]
        FormulaState.new
      else
        StateBase::Refused.new
      end
    end

    def refused_match
      Formula.operation_chars.map { |char| [char, nil] }
    end
  end

  class FormulaState < StateBase
    def next_state(input)
      case [input, top]
      when ['(', nil]
        ParenthesesParser::SemiBalance.new([input] + stack)
      when [' ', nil]
        StateBase::Accepted.new
      when *accepted_match
        StateBase::Accepted.new
      when [input, nil]
        FormulaState.new(stack)
      else
        StateBase::Refused.new
      end
    end

    def accepted_match
      (Formula.operation_chars+[nil]).map { |char| [char, nil] }
    end
  end
end
