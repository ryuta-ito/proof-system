# Γ |- P(t)    <- theorem_a
# ------ (∃ I)
# Γ |- ∃x.P(x) <- theorem_b
#
# ∃θ.( P(t)θ ≡ P(x)θ )
# θ ≡ [t/x]

require 'rules/commons/assumption'

module Rules::Introduces::Existence
  extend Rules::Commons::Assumption

  def self.satisfy?(deduction)
    theorem_a = deduction.upper_sequents.first.theorem
    theorem_b = deduction.lower_sequent.theorem
    bounded_variable = theorem_b.bounded_variable

    return false unless assumptions_equal?(deduction) && Existence === theorem_b

    unifier = theorem_a.unify(theorem_b.formula)

    (Unifier === unifier) &&
      (unifier.substitutions.any? { |substitution| substitution.target.identify?(bounded_variable) }) &&
      (theorem_b.formula.free_variables.any? { |variable| bounded_variable.identify?(variable) })
  end
end
