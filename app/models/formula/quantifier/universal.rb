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

  def expantion_tableux_consequence(tableau)
    instance_formula = formula.substitute(bounded_variable, tableau.non_used_constant)
    Tableaux::Series.new( tableaux: [ Tableau::Consequence.new( formula: instance_formula ) ] )
  end

  def expantion_tableux_assumption(tableau)
    instance_formulas = tableau.least_constants.map { |constant| formula.substitute(bounded_variable, constant) }
    Tableaux::Series.new( tableaux: instance_formulas.map { |formula| Tableau::Assumption.new( formula: formula )})
  end
end
