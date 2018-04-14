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

  # A ∧ (B ∨ C) -> (A ∧ B) ∨ (A ∧ C)
  # (A ∨ B) ∧ C -> (A ∧ C) ∨ (B ∧ C)
  def disjunctive_normal
    if Disjunction === right
      Disjunction.new left: (Conjunction.new left: left, right: right.left).disjunctive_normal,
                      right: (Conjunction.new left: left, right: right.right).disjunctive_normal
    elsif Disjunction === left
      Disjunction.new left: (Conjunction.new left: left.left, right: right).disjunctive_normal,
                      right: (Conjunction.new left: left.right, right: right).disjunctive_normal
    elsif left.literal? and right.literal?
      self
    else
      (Conjunction.new left: left.disjunctive_normal, right: right.disjunctive_normal).disjunctive_normal
    end
  end

  def conjunctive_normal
    Conjunction.new left: left.conjunctive_normal,
                    right: right.conjunctive_normal
  end
end
