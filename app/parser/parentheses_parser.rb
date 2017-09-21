require 'parser/parser_base'
require 'parser/state_base'

module ParenthesesParser
  extend ParserBase

  class << self
    def strip_edge_parentheses(_data)
      data = _data.strip
      if [data, "", :accepted] == divide(data)
        strip_edge_parentheses(strip_edge(data))
      else
        data
      end
    end

    private

    def strip_edge(data)
      data.sub(/^./, '').sub(/.$/, '')
    end

    def start_state_class
      State
    end
  end

  class State < StateBase
    def next_state(input)
      case [name, input, stack.first]
      when [:start, '(', nil]
        State.new(:semi_balance, [input] + stack)
      when [:start, input, nil]
        State.new(:refused, [])
      when [:semi_balance, ')', '(']
        State.new(:semi_balance, stack.drop(1))
      when [:semi_balance, ')', ')']
        State.new(:semi_balance, [input] + stack)
      when [:semi_balance, '(', '(']
        State.new(:semi_balance, [input] + stack)
      when [:semi_balance, '(', ')']
        State.new(:refused, [])
      when [:semi_balance, ')', nil]
        State.new(:refused, [])
      when [:semi_balance, input, nil]
        State.new(:accepted, [])
      when [:semi_balance, input, stack.first]
        State.new(:semi_balance, stack)
      else
        State.new(:refused, [])
      end
    end
  end
end
