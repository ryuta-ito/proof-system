class Rules
  attr_accessor :name

  extend Forwardable

  def_delegator :name, :empty?

  class << self
    def build(name)
      new.tap do |rule|
        rule.name = name
      end
    end
  end

  def show
    puts str
  end

  def str
    "(#{name})"
  end

  def module
    case name
    when '=> E'
      Rules::Eliminations::Imply
    when '=> I'
      Rules::Introduces::Imply
    when '∧ E'
      Rules::Eliminations::Conjunction
    when '∧ I'
      Rules::Introduces::Conjunction
    when '∨ E'
      Rules::Eliminations::Disjunction
    when '∨ I'
      Rules::Introduces::Disjunction
    when '∃ E'
      Rules::Eliminations::Existence
    when '∃ I'
      Rules::Introduces::Existence
    when '∀ E'
      Rules::Eliminations::Universal
    when '∀ I'
      Rules::Introduces::Universal
    when '¬ E'
      Rules::Eliminations::Negation
    when '¬ I'
      Rules::Introduces::Negation
    else
      raise UnknownRuleName, "no such rule #{name}"
    end
  end

  class UnknownRuleName < StandardError; end
end
