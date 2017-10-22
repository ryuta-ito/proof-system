# disjunction:
#   <formula> ∨ <formula>

class Disjunction < Formula::Binary
  def self.code
    '∨'
  end

  def deductive_sequents_consequece(sequent)
    [ Sequent.new( axiom: sequent.axiom, consequece: sequent.consequece.substitute(self, [left, right]) ) ]
  end

  def deductive_sequents_axiom(sequent)
    [ Sequent.new( axiom: sequent.axiom.substitute(self, left), consequece: sequent.consequece ),
      Sequent.new( axiom: sequent.axiom.substitute(self, right), consequece: sequent.consequece ) ]
  end
end
