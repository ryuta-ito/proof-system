# Γ |- P      --> sequent_a
# ------ (∨ I)
# Γ |- P ∨ Q. --> sequent_b
#
# Γ |- Q      --> sequent_a
# ------ (∨ I)
# Γ |- P ∨ Q. --> sequent_b

require 'rules/commons/axiom'

module Rules::Introduces::Disjunction
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    sequent_a = deduction.upper_sequents.first
    sequent_b = deduction.lower_sequent

    axioms_equal?(deduction) &&
      Disjunction === sequent_b.theorem &&
      ( sequent_b.theorem.left.identify?(sequent_a.theorem) ||
        sequent_b.theorem.right.identify?(sequent_a.theorem) )
  end
end
