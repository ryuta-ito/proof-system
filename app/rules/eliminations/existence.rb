# Γ |- ∃x.P(x)    <- sequent_a
# Γ, P(x) |- Q    <- sequent_b
# ------ (∃ E)
# Γ |- Q          <- sequent_c
#
# x ∉ FV(Γ, Q)

require 'rules/commons/axiom'

module Rules::Eliminations::Existence
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    sequent_a, sequent_b  = deduction.upper_sequents
    sequent_c = deduction.lower_sequent
    bounded_variable = sequent_a.theorem.bounded_variable

    (Existence === sequent_a.theorem) &&
      (sequent_a.axiom.xor_diff(sequent_b.axiom).formulas.first.identify?(sequent_a.theorem.formula)) &&
      (sequent_b.theorem.identify? sequent_c.theorem) &&
      !((sequent_a.axiom.free_variables + sequent_b.theorem.free_variables).any? {|variable| variable.identify?(bounded_variable)})
  end
end
