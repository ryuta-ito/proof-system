# Γ |- P ∧ Q   --> proof_a
# ------ (∧ E)
# Γ |- P.      --> proof_b
#
# Γ |- P ∧ Q   --> proof_a
# ------ (∧ E)
# Γ |- Q.      --> proof_b

require 'rules/eliminations'
require 'rules/commons/axiom'

module Rules::Eliminations::Conjunction
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    proof_a = deduction.upper_proofs.first
    proof_b = deduction.lower_proof

    axioms_equal?(deduction) &&
      Conjunction === proof_a.theorem &&
      ( proof_a.theorem.left.identify?(proof_b.theorem) ||
        proof_a.theorem.right.identify?(proof_b.theorem) )
  end
end
