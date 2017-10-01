# Γ |- P(x)       <- proof_a
# ------ (∀ I)
# Γ |- ∀x.P(x) <- proof_b
#
# x ∉ FV(Γ)

require 'rules/commons/axiom'

module Rules::Introduces::Universal
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    proof_a, _ = deduction.upper_proofs
    proof_b = deduction.lower_proof
    bounded_variable = proof_b.theorem.bounded_variable

    (Universal === proof_b.theorem) &&
      axioms_equal?(deduction) &&
      proof_a.theorem.identify?(proof_b.theorem.formula) &&
      !(proof_a.axiom.free_variables.any? { |variable| bounded_variable.identify?(variable) })
  end
end
