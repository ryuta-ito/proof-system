# Γ |- P ∧ Q   --> sequent_a
# ------ (∧ E)
# Γ |- P.      --> sequent_b
#
# Γ |- P ∧ Q   --> sequent_a
# ------ (∧ E)
# Γ |- Q.      --> sequent_b

require 'rules/eliminations'
require 'rules/commons/axiom'

module Rules::Eliminations::Conjunction
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    sequent_a = deduction.upper_sequents.first
    sequent_b = deduction.lower_sequent

    axioms_equal?(deduction) &&
      Conjunction === sequent_a.theorem &&
      ( sequent_a.theorem.left.identify?(sequent_b.theorem) ||
        sequent_a.theorem.right.identify?(sequent_b.theorem) )
  end
end
