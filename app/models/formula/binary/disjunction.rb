# disjunction:
#   <formula> ∨ <formula>

class Disjunction < Formula::Binary
  def self.code
    '∨'
  end

  def deductive_sequents_consequence(sequent)
    [ Sequent.new( assumption: sequent.assumption, consequence: sequent.consequence.substitute(self, [left, right]) ) ]
  end

  def deductive_sequents_assumption(sequent)
    [ Sequent.new( assumption: sequent.assumption.substitute(self, left), consequence: sequent.consequence ),
      Sequent.new( assumption: sequent.assumption.substitute(self, right), consequence: sequent.consequence ) ]
  end

  def expantion_tableux_consequence
    Tableaux::Series.new( tableaux: [ Tableau::Consequence.new( formula: left ), Tableau::Consequence.new( formula: right ) ])
  end

  def expantion_tableux_assumption
    Tableaux::Parallel.new( tableaux: [ Tableau::Assumption.new( formula: left ), Tableau::Assumption.new( formula: right ) ])
  end
end
