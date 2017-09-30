# substitution:
#   [<term> / <variable>]
#
# substitutions:
#   [<term_1> / <variable_1>, ... , <term_n> / <variable_n>]
#
# x[t/x] ≡ t
# y[t/x] ≡ y
# c[t/x] ≡ c
# f(t_1, ..., t_n)[s/x] ≡ f(t_1[s/x], ..., t_n[s/x])

class Substitutions
  attr_accessor :substitutions

  def self.build(replace = nil, target = nil)
    if (replace && target)
      new([Substitution.new(replace, target)])
    else
      new([])
    end
  end

  def initialize(substitutions)
    @substitutions = substitutions
  end

  def str
  end

  def apply(term)
    substitutions.reduce(term) do |result_term, substitution|
      substitution.apply(result_term)
    end
  end

  def compose(target_substitutions)
    not_belong_target_substitutions = target_substitutions.select do |target_substitution|
      substitutions.any? do |substitution|
        !substitution.target.identify?(target_substitution.target)
      end
    end
    composed_substitutions = substitutions.map do |substitution|
      substitution.compose(target_substitutions)
    end

    self.class.new(composed_substitutions + not_belong_target_substitutions)
  end

  def reduce(init_term)
    substitutions.reduce(init_term) do |term, substitution|
      yield term, substitution
    end
  end

  def select
    substitutions.select do |substitution|
      yield substitution
    end
  end

  class Substitution
    attr_accessor :replace, :target

    def initialize(replace, target)
      @replace = replace
      @target = target
    end

    def show
      puts str
    end

    def str
      "[#{replace.str}/#{target.str}]"
    end

    def compose(substitutions)
      composed_replace = substitutions.reduce(replace) do |term, substitution|
        substitution.apply term
      end
      self.class.new(composed_replace, target)
    end

    def apply(term)
      term.substitute(target, replace)
    end
  end
end
