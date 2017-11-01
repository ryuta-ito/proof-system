# Γ |- ∃x.P(x)    <- sequent_a
# Γ, P(x) |- Q    <- sequent_b
# ------ (∃ E)
# Γ |- Q          <- sequent_c
#
# x ∉ FV(Γ, Q)

require 'rules/commons/assumption'

module Rules::Eliminations::Existence
  extend Rules::Commons::Assumption

  def self.satisfy?(deduction)
    sequent_a, sequent_b  = deduction.upper_sequents
    sequent_c = deduction.lower_sequent

    [sequent_a, sequent_b].permutation.any? do |sequent_a, sequent_b|
      (Existence === sequent_a.theorem) &&
        (sequent_a.assumption.xor_diff(sequent_b.assumption).formulas.first.identify?(sequent_a.theorem.formula)) &&
        (sequent_b.theorem.identify? sequent_c.theorem) &&
        !((sequent_a.assumption.free_variables + sequent_b.theorem.free_variables).any? {|variable| variable.identify?(sequent_a.theorem.bounded_variable)})
    end
  end
end
