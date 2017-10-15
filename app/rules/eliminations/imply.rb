# Γ |- P => Q  --> sequent_a
# Γ |- P       --> sequent_b
# ------ (=> E)
# Γ |- Q.

require 'rules/eliminations'

module Rules::Eliminations::Imply
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    sequent_a, sequent_b = deduction.upper_sequents

    axioms_equal?(deduction) &&
      Imply === sequent_a.theorem &&
      sequent_a.theorem.left.identify?(sequent_b.theorem) &&
      sequent_a.theorem.right.identify?(deduction.lower_sequent.theorem)
  end
end
