# conjunction:
#   <formula> ∧ <formula>

class Conjunction < Formula::Binary
  def self.code
    '∧'
  end

  def deductive_sequents_consequece(sequent)
    [ Sequent.new( axiom: sequent.axiom, consequece: sequent.consequece.substitute(self, left) ),
      Sequent.new( axiom: sequent.axiom, consequece: sequent.consequece.substitute(self, right) ) ]
  end

  def deductive_sequents_axiom(sequent)
    [ Sequent.new( axiom: sequent.axiom.substitute(self, [left, right]), consequece: sequent.consequece ) ]
  end
end
