# Γ |- P(x)       <- sequent_a
# ------ (∀ I)
# Γ |- ∀x.P(x) <- sequent_b
#
# x ∉ FV(Γ)

require 'rules/commons/axiom'

module Rules::Introduces::Universal
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    sequent_a, _ = deduction.upper_sequents
    sequent_b = deduction.lower_sequent
    bounded_variable = sequent_b.theorem.bounded_variable

    (Universal === sequent_b.theorem) &&
      axioms_equal?(deduction) &&
      sequent_a.theorem.identify?(sequent_b.theorem.formula) &&
      !(sequent_a.axiom.free_variables.any? { |variable| bounded_variable.identify?(variable) })
  end
end
