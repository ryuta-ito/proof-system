# Γ    |- P ∨ Q --> proof_a
# Γ, P |- R     --> proof_b
# Γ, Q |- R     --> proof_c
# ------ (∨ E)
# Γ    |- R.    --> proof_d

require 'rules/eliminations'

module Rules::Eliminations::Disjunction
  def self.satisfy?(deduction)
    proof_a, proof_b, proof_c = deduction.upper_proofs
    proof_d = deduction.lower_proof

    Disjunction === proof_a.theorem &&
      proof_b.theorem.identify?(proof_c.theorem) &&
      proof_c.theorem.identify?(proof_d.theorem) &&
      proof_b.axiom.diff(proof_a.axiom).formulas.first.identify?(proof_a.theorem.left) &&
      proof_c.axiom.diff(proof_a.axiom).formulas.first.identify?(proof_a.theorem.right)
  end
end
