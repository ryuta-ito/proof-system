# function:
#   <function_name>(<term_1> ... <term_n>)

class Function < Term
  attr_accessor :function_name, :arguments

  class << self
    def build(function_data)
      new.tap do |function|
        function.function_name = parse_function_name(function_data)
        function.arguments = parse_arguments(function_data).map do |term|
          super term
        end
      end
    end

    private

    def parse_function_name(function_data)
      function_data.include?('(') ? function_data.split('(').first.strip : ''
    end

    def parse_arguments(function_data)
      TermParser.split strip_function(function_data)
    end

    def strip_function(function_data)
      function_data.sub(/^\w+\(/, '').sub(/\)$/, '')
    end
  end

  def str
    arguments_data = arguments.map(&:str).join(' ')
    "#{function_name}(#{arguments_data})"
  end

  def identify?(function)
    if self.class === function
      function.function_name == function_name &&
        (function.arguments.zip arguments).all? do |term_a, term_b|
          term_a.identify? term_b
        end
    else
      false
    end
  end

  def free_variables
    arguments.flat_map { |term| term.free_variables }
  end

  def substitute(target, replace)
    if identify?(target)
      replace
    else
      arguments_data = arguments.map do |term|
        term.substitute(target, replace)
      end.map(&:str).join(' ')
      self.class.build "#{function_name}(#{arguments_data})"
    end
  end

  def unify(term)
    case term
    when Constant
      NonUnifier.build
    when Variable
      term.unify self
    when Function
      unify_function term
    end
  end

  private

  def unify_function(target)
    if arguments.size == target.arguments.size && function_name == target.function_name
      arguments.zip(target.arguments).reduce(Unifier.build) do |unifier, (term_a, term_b)|
        unifier.compose term_a.unify(term_b)
      end
    else
      NonUnifier.build
    end
  end
end
