# Γ |- P
# Γ |- ¬P
# ------ (¬ E)
# Γ |- ⊥

require 'rules/eliminations'
require 'rules/commons/assumption'

module Rules::Eliminations::Negation
  extend Rules::Commons::Assumption

  def self.satisfy?(deduction)
    sequent_a, sequent_b = deduction.upper_sequents
    sequent_c = deduction.lower_sequent

    [sequent_a, sequent_b].permutation.any? do |sequent_a, sequent_b|
      Negation === sequent_b.theorem &&
        sequent_a.theorem.identify?(sequent_b.theorem.formula) &&
        Contradiction === sequent_c.theorem &&
        assumptions_equal?(deduction)
    end
  end
end
