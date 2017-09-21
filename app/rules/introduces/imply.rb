# Γ, P |- Q     --> proof_a
# ------ (=> I)
# Γ |- P => Q   --> proof_b

require 'rules/introduces'
require 'rules/commons/axiom'

module Rules::Introduces::Imply
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    proof_a = deduction.upper_proofs.first
    proof_b = deduction.lower_proof

    proof_a.theorem.identify?(proof_b.theorem.right) &&
      proof_a.axiom.formulas.any? { |formula| formula.identify?(proof_b.theorem.left) } &&
      proof_a.axiom.xor_diff(proof_b.axiom).formulas.first.identify?(proof_b.theorem.left)
  end
end
