# Γ |- P
# Γ |- ¬P
# ------ (¬ E)
# Γ |- ⊥

require 'rules/eliminations'
require 'rules/commons/axiom'

module Rules::Eliminations::Negation
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    proof_a, proof_b = deduction.upper_proofs
    proof_c = deduction.lower_proof

    Negation === proof_b.theorem &&
      proof_a.theorem.identify?(proof_b.theorem.formula) &&
      Contradiction === proof_c.theorem &&
      axioms_equal?(deduction)
  end
end
