class StateBase
  attr_accessor :stack

  def initialize(stack = [])
    @stack = stack
  end

  def next_state(input)
    raise NotImplementedError
  end

  def top
    stack.first
  end

  class Refused < StateBase; end
  class Accepted < StateBase; end
end
