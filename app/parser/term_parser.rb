# "x t_1 t_2" =split=> ["x", "t_1", "t_2"]
# "c t_1 t_3" =split=> ["c", "t_1", "t_2"]
# "f(t_1 ... t_n) t'_1 t'_2" =split=> ["f(t_1 ... t_n)", "t'_1", "t'_2"]

require 'parser/parser_base'
require 'parser/state_base'

module TermParser
  extend ParserBase

  def self.start_state
    Start.new
  end
  private_class_method :start_state

  class Start < StateBase
    def next_state(input)
      case [input, top]
      when *refused_match
        StateBase::Refused.new
      when [input, nil]
        Term.new(stack)
      else
        StateBase::Refused.new
      end
    end

    def refused_match
      Formula.operation_chars.map { |char| [char, nil] } << ['(', nil]
    end
  end

  class Term < StateBase
    def next_state(input)
      case [input, top]
      when ['(', nil]
        ParenthesesParser::SemiBalance.new([input] + stack)
      when [' ', nil]
        StateBase::Accepted.new
      when *refused_match
        StateBase::Refused.new
      when [input, nil]
        Term.new(stack)
      else
        StateBase::Refused.new
      end
    end

    def refused_match
      Formula.operation_chars.map { |char| [char, nil] } << ['(', nil]
    end
  end
end
