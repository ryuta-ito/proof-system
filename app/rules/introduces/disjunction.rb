# Γ |- P      --> proof_a
# ------ (∨ I)
# Γ |- P ∨ Q. --> proof_b
#
# Γ |- Q      --> proof_a
# ------ (∨ I)
# Γ |- P ∨ Q. --> proof_b

require 'rules/commons/axiom'

module Rules::Introduces::Disjunction
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    proof_a = deduction.upper_proofs.first
    proof_b = deduction.lower_proof

    axioms_equal?(deduction) &&
      Disjunction === proof_b.theorem &&
      ( proof_b.theorem.left.identify?(proof_a.theorem) ||
        proof_b.theorem.right.identify?(proof_a.theorem) )
  end
end
