# existence:
#   ∀<bounded_variable>.<formula>

class Universal < Formula::Quantifier
  def self.code
    '∀'
  end

  # delta
  def deductive_sequents_consequence(sequent)
    instance_formula = formula.substitute(bounded_variable, sequent.non_used_constant)
    [ Sequent.new( assumption: sequent.assumption, consequence: sequent.consequence.substitute(self, instance_formula) ) ]
  end

  # gamma
  def deductive_sequents_assumption(sequent)
    instance_formulas = sequent.least_constants.map { |constant| formula.substitute(bounded_variable, constant) }
    [ Sequent.new( assumption: sequent.assumption.add_formulas(instance_formulas), consequence: sequent.consequence ) ]
  end
end
