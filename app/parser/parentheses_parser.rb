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

    def start_state
      Start.new([])
    end
  end

  class Start < StateBase
    def next_state(input)
      case [input, top]
      when ['(', nil]
        SemiBalance.new([input] + stack)
      when [input, nil]
        StateBase::Refused.new([])
      else
        StateBase::Refused.new([])
      end
    end
  end

  class SemiBalance < StateBase
    def next_state(input)
      case [input, top]
      when [')', '(']
        SemiBalance.new(stack.drop(1))
      when [')', ')']
        SemiBalance.new([input] + stack)
      when ['(', '(']
        SemiBalance.new([input] + stack)
      when ['(', ')']
        StateBase::Refused.new([])
      when [')', nil]
        StateBase::Refused.new([])
      when [input, nil]
        StateBase::Accepted.new([])
      when [input, stack.first]
        SemiBalance.new(stack)
      end
    end
  end
end
