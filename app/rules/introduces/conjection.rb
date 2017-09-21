# Γ |- P       --> proof_a
# Γ |- Q       --> proof_b
# ------ (∧ I)
# Γ |- P ∧ Q.  --> proof_c

require 'rules/introduces'

module Rules::Introduces::Conjunction
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    proof_a, proof_b = deduction.upper_proofs
    proof_c = deduction.lower_proof

    axioms_equal?(deduction) &&
      Conjunction === proof_c.theorem &&
      proof_c.theorem.left.identify?(proof_a.theorem) &&
      proof_c.theorem.right.identify?(proof_b.theorem)
  end
end
