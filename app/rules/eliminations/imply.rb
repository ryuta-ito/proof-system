# Γ |- P => Q  --> proof_a
# Γ |- P       --> proof_b
# ------ (=> E)
# Γ |- Q.

require 'rules/eliminations'

module Rules::Eliminations::Imply
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    proof_a, proof_b = deduction.upper_proofs

    axioms_equal?(deduction) &&
      Imply === proof_a.theorem &&
      proof_a.theorem.left.identify?(proof_b.theorem) &&
      proof_a.theorem.right.identify?(deduction.lower_proof.theorem)
  end
end
