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
end
