# Γ |- P => Q  --> sequent_a
# Γ |- P       --> sequent_b
# ------ (=> E)
# Γ |- Q.

require 'rules/eliminations'

module Rules::Eliminations::Imply
  extend Rules::Commons::Assumption

  def self.satisfy?(deduction)
    sequent_a, sequent_b = deduction.upper_sequents

    [sequent_a, sequent_b].permutation.any? do |sequent_a, sequent_b|
      assumptions_equal?(deduction) &&
        Imply === sequent_a.theorem &&
        sequent_a.theorem.left.identify?(sequent_b.theorem) &&
        sequent_a.theorem.right.identify?(deduction.lower_sequent.theorem)
    end
  rescue
    binding.pry
  end
end
