# Γ |- P       --> sequent_a
# Γ |- Q       --> sequent_b
# ------ (∧ I)
# Γ |- P ∧ Q.  --> sequent_c

require 'rules/introduces'

module Rules::Introduces::Conjunction
  extend Rules::Commons::Assumption

  def self.satisfy?(deduction)
    sequent_a, sequent_b = deduction.upper_sequents
    sequent_c = deduction.lower_sequent

    [sequent_a, sequent_b].permutation.any? do |sequent_a, sequent_b|
      assumptions_equal?(deduction) &&
        Conjunction === sequent_c.theorem &&
        sequent_c.theorem.left.identify?(sequent_a.theorem) &&
        sequent_c.theorem.right.identify?(sequent_b.theorem)
    end
  end
end
