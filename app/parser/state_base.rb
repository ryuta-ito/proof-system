class StateBase
  attr_accessor :name, :stack

  def self.start_state
    new(:start, [])
  end

  def initialize(name, stack)
    @name = name
    @stack = stack
  end

  def next_state(input)
    raise NotImplementedError
  end

  def top
    stack.first
  end
end
