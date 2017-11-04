class Rules
  attr_accessor :name

  include ActiveModel::Model
  extend Forwardable

  def_delegator :name, :empty?

  class << self
    def build_empty
      new name: ''
    end

    def build_by_figure(figure_data)
      if figure_data.match(/------.+\(.+\)/)
        new name: figure_data.match(/------.+\((?<rule_name>.+)\)/)[:rule_name]
      else
        build_empty
      end
    end

    def build_by_reverse_figure(figure_data)
      build_by_figure figure_data.strip.split("\n").reverse.join("\n")
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
