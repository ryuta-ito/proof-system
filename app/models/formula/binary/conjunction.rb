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
end
