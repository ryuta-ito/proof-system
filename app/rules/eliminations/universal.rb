# Γ |- ∀x.P(x) <- proof_a
# ------ (∀ E)
# Γ |- P(t)    <- proof_b
#
# x ∉ FV(Γ)

require 'rules/commons/axiom'

module Rules::Eliminations::Universal
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    proof_a, _ = deduction.upper_proofs
    proof_b = deduction.lower_proof
    bounded_variable = proof_a.theorem.bounded_variable

    unifier = proof_a.theorem.formula.unify(proof_b.theorem)

    (Universal === proof_a.theorem) &&
      (Unifier === unifier) &&
      axioms_equal?(deduction) &&
      proof_b.theorem.free_variables.all? { |variable| !bounded_variable.identify?(variable) }
  end
end
