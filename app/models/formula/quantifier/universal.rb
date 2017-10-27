# existence:
#   ∀<bounded_variable>.<formula>

class Universal < Formula::Quantifier
  def self.code
    '∀'
  end

  # delta
  def deductive_sequents_consequece(sequent)
    instance_formula = formula.substitute(bounded_variable, sequent.non_used_constant)
    [ Sequent.new( assumption: sequent.assumption, consequece: sequent.consequece.substitute(self, instance_formula) ) ]
  end

  # gamma
  def deductive_sequents_assumption(sequent)
    instance_formulas = sequent.least_constants.map { |constant| formula.substitute(bounded_variable, constant) }
    [ Sequent.new( assumption: sequent.assumption.add_formulas(instance_formulas), consequece: sequent.consequece ) ]
  end
end
