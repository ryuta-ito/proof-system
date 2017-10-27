# Γ    |- P ∨ Q --> sequent_a
# Γ, P |- R     --> sequent_b
# Γ, Q |- R     --> sequent_c
# ------ (∨ E)
# Γ    |- R.    --> sequent_d

require 'rules/eliminations'

module Rules::Eliminations::Disjunction
  def self.satisfy?(deduction)
    sequent_a, sequent_b, sequent_c = deduction.upper_sequents
    sequent_d = deduction.lower_sequent

    Disjunction === sequent_a.theorem &&
      sequent_b.theorem.identify?(sequent_c.theorem) &&
      sequent_c.theorem.identify?(sequent_d.theorem) &&
      sequent_b.assumption.diff(sequent_a.assumption).formulas.first.identify?(sequent_a.theorem.left) &&
      sequent_c.assumption.diff(sequent_a.assumption).formulas.first.identify?(sequent_a.theorem.right)
  end
end
