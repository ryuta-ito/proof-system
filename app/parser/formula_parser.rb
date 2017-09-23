# (A => B) ∨ C ∧ B =divide=> ['A => B', '∨ C ∧ B']
# (A => B) ∨ C ∧ B =split=> ['A => B', '∨', 'C', '∧', 'B']

require 'parser/parser_base'
require 'parser/state_base'

module FormulaParser
  extend ParserBase

  class << self
    def split_divide(data)
      disjunction_divide([ParenthesesParser, OperationParser], data)
    end

    private

    def start_state
      Start.new
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
