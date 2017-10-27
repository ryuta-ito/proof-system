# Γ, P |- Q     --> sequent_a
# ------ (=> I)
# Γ |- P => Q   --> sequent_b

require 'rules/introduces'
require 'rules/commons/assumption'

module Rules::Introduces::Imply
  extend Rules::Commons::Assumption

  def self.satisfy?(deduction)
    sequent_a = deduction.upper_sequents.first
    sequent_b = deduction.lower_sequent

    sequent_a.theorem.identify?(sequent_b.theorem.right) &&
      sequent_a.assumption.formulas.any? { |formula| formula.identify?(sequent_b.theorem.left) } &&
      sequent_a.assumption.xor_diff(sequent_b.assumption).formulas.first.identify?(sequent_b.theorem.left)
  end
end
