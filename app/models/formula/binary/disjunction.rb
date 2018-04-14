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

  def disjunctive_normal
    Disjunction.new left: left.disjunctive_normal,
                    right: right.disjunctive_normal
  end

  # A ∨ (B ∧ C) -> (A ∨ B) ∧ (A ∨ C)
  # (A ∧ B) ∨ C -> (A ∨ C) ∧ (B ∨ C)
  def conjunctive_normal
    if Conjunction === right
      Conjunction.new left: (Disjunction.new left: left, right: right.left).conjunctive_normal,
                      right: (Disjunction.new left: left, right: right.right).conjunctive_normal
    elsif Conjunction === left
      Conjunction.new left: (Disjunction.new left: left.left, right: right).conjunctive_normal,
                      right: (Disjunction.new left: left.right, right: right).conjunctive_normal
    elsif left.literal? and right.literal?
      self
    else
      (Conjunction.new left: left.conjunctive_normal, right: right.conjunctive_normal).conjunctive_normal
    end
  end
end
