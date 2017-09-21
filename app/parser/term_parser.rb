# "x t_1 t_2" =split=> ["x", "t_1", "t_2"]
# "c t_1 t_3" =split=> ["c", "t_1", "t_2"]
# "f(t_1 ... t_n) t'_1 t'_2" =split=> ["f(t_1 ... t_n)", "t'_1", "t'_2"]

require 'parser/parser_base'
require 'parser/state_base'

module TermParser
  extend ParserBase

  def self.start_state_class
    State
  end
  private_class_method :start_state_class

  class State < StateBase
    def next_state(input)
      case [name, input, top]
      when [:start, '(', nil]
        State.new(:refused, [])
      when [:start, input, nil]
        State.new(:term, stack)
      when [:term, '(', nil]
        ParenthesesParser::State.new(:semi_balance, [input] + stack)
      when [:term, ' ', nil]
        State.new(:accepted, stack)
      when [:term, input, nil]
        State.new(:term, stack)
      else
        State.new(:refused, [])
      end
    end
  end
end
