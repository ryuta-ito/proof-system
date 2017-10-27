# Γ |- ∀x.P(x) <- sequent_a
# ------ (∀ E)
# Γ |- P(t)    <- sequent_b
#
# x ∉ FV(Γ)

require 'rules/commons/axiom'

module Rules::Eliminations::Universal
  extend Rules::Commons::Assumption

  def self.satisfy?(deduction)
    sequent_a, _ = deduction.upper_sequents
    sequent_b = deduction.lower_sequent
    bounded_variable = sequent_a.theorem.bounded_variable

    unifier = sequent_a.theorem.formula.unify(sequent_b.theorem)

    (Universal === sequent_a.theorem) &&
      (Unifier === unifier) &&
      axioms_equal?(deduction) &&
      sequent_b.theorem.free_variables.all? { |variable| !bounded_variable.identify?(variable) }
  end
end
