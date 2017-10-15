# Γ |- P
# Γ |- ¬P
# ------ (¬ E)
# Γ |- ⊥

require 'rules/eliminations'
require 'rules/commons/axiom'

module Rules::Eliminations::Negation
  extend Rules::Commons::Axiom

  def self.satisfy?(deduction)
    sequent_a, sequent_b = deduction.upper_sequents
    sequent_c = deduction.lower_sequent

    Negation === sequent_b.theorem &&
      sequent_a.theorem.identify?(sequent_b.theorem.formula) &&
      Contradiction === sequent_c.theorem &&
      axioms_equal?(deduction)
  end
end
