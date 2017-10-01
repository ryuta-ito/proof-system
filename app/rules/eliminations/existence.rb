# Γ |- ∃x.P(x)    <- proof_a
# Γ, P(x) |- Q    <- proof_b
# ------ (∃ E)
# Γ |- Q          <- proof_c
#
# x ∉ FV(Γ, Q)

require 'rules/commons/axiom'

module Rules::Eliminations::Existence
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    proof_a, proof_b  = deduction.upper_proofs
    proof_c = deduction.lower_proof
    bounded_variable = proof_a.theorem.bounded_variable

    (Existence === proof_a.theorem) &&
      (proof_a.axiom.xor_diff(proof_b.axiom).formulas.first.identify?(proof_a.theorem.formula)) &&
      (proof_b.theorem.identify? proof_c.theorem) &&
      !((proof_a.axiom.free_variables + proof_b.theorem.free_variables).any? {|variable| variable.identify?(bounded_variable)})
  end
end
