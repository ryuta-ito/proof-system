# Γ, P |- ⊥ --> sequent_a
# ------ (¬ I)
# Γ |- ¬P   --> sequent_b

require 'rules/introduces'

module Rules::Introduces::Negation
  def self.satisfy?(deduction)
    sequent_a = deduction.upper_sequents.first
    sequent_b = deduction.lower_sequent

    Contradiction === sequent_a.theorem &&
      Negation === sequent_b.theorem &&
      sequent_b.theorem.formula.identify?(sequent_a.assumption.diff(sequent_b.assumption).formulas.first)
  end
end
