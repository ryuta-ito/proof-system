# Γ |- P(x)       <- sequent_a
# ------ (∀ I)
# Γ |- ∀x.P(x) <- sequent_b
#
# x ∉ FV(Γ)

require 'rules/commons/assumption'

module Rules::Introduces::Universal
  extend Rules::Commons::Assumption

  def self.satisfy?(deduction)
    sequent_a, _ = deduction.upper_sequents
    sequent_b = deduction.lower_sequent
    bounded_variable = sequent_b.theorem.bounded_variable

    (Universal === sequent_b.theorem) &&
      assumptions_equal?(deduction) &&
      sequent_a.theorem.identify?(sequent_b.theorem.formula) &&
      !(sequent_a.assumption.free_variables.any? { |variable| bounded_variable.identify?(variable) })
  end
end
