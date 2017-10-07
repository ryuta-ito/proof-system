# Γ, P |- ⊥ --> proof_a
# ------ (¬ I)
# Γ |- ¬P   --> proof_b

require 'rules/introduces'

module Rules::Introduces::Negation
  def self.satisfy?(deduction)
    proof_a = deduction.upper_proofs.first
    proof_b = deduction.lower_proof

    Contradiction === proof_a.theorem &&
      Negation === proof_b.theorem &&
      proof_b.theorem.formula.identify?(proof_a.axiom.diff(proof_b.axiom).formulas.first)
  end
end
