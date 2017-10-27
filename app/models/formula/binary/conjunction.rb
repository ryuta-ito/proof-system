# conjunction:
#   <formula> ∧ <formula>

class Conjunction < Formula::Binary
  def self.code
    '∧'
  end

  def deductive_sequents_consequece(sequent)
    [ Sequent.new( assumption: sequent.assumption, consequece: sequent.consequece.substitute(self, left) ),
      Sequent.new( assumption: sequent.assumption, consequece: sequent.consequece.substitute(self, right) ) ]
  end

  def deductive_sequents_assumption(sequent)
    [ Sequent.new( assumption: sequent.assumption.substitute(self, [left, right]), consequece: sequent.consequece ) ]
  end
end
