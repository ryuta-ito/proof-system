class Rules
  attr_accessor :name

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
    else
      raise UnknownRuleName, "no such rule #{name}"
    end
  end

  class UnknownRuleName < StandardError; end
end
