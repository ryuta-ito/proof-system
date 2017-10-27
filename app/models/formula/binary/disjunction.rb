# disjunction:
#   <formula> ∨ <formula>

class Disjunction < Formula::Binary
  def self.code
    '∨'
  end

  def deductive_sequents_consequece(sequent)
    [ Sequent.new( assumption: sequent.assumption, consequece: sequent.consequece.substitute(self, [left, right]) ) ]
  end

  def deductive_sequents_assumption(sequent)
    [ Sequent.new( assumption: sequent.assumption.substitute(self, left), consequece: sequent.consequece ),
      Sequent.new( assumption: sequent.assumption.substitute(self, right), consequece: sequent.consequece ) ]
  end
end
