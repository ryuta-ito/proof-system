# conjunction:
#   <formula> ∧ <formula>

class Conjunction < Formula::Binary
  def self.code
    '∧'
  end

  def deductive_sequents_consequence(sequent)
    [ Sequent.new( assumption: sequent.assumption, consequence: sequent.consequence.substitute(self, left) ),
      Sequent.new( assumption: sequent.assumption, consequence: sequent.consequence.substitute(self, right) ) ]
  end

  def deductive_sequents_assumption(sequent)
    [ Sequent.new( assumption: sequent.assumption.substitute(self, [left, right]), consequence: sequent.consequence ) ]
  end

  def expantion_tableux_consequence
    Tableaux::Parallel.new( tableaux: [ Tableau::Consequence.new( formula: left ), Tableau::Consequence.new( formula: right ) ])
  end

  def expantion_tableux_assumption
    Tableaux::Series.new( tableaux: [ Tableau::Assumption.new( formula: left ), Tableau::Assumption.new( formula: right ) ])
  end
end
