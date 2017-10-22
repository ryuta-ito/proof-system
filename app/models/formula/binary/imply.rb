# imply:
#   <formula> => <formula>

class Imply < Formula::Binary
  def self.code
    '=>'
  end

  # Γ |- Δ, A => B
  # ------
  # Γ, A |- Δ, B
  def deductive_sequents_consequece(sequent)
    [ Sequent.new( axiom: sequent.axiom.add_formula(left), consequece: sequent.consequece.substitute(self, [right]) ) ]
  end

  # Γ, A => B |- Δ
  # ------
  # Γ |- Δ, A
  # Γ, B |- Δ
  def deductive_sequents_axiom(sequent)
    [ Sequent.new( axiom: sequent.axiom.delete_formula(self), consequece: sequent.consequece.add_formula(left) ),
      Sequent.new( axiom: sequent.axiom.substitute(self, right), consequece: sequent.consequece ) ]
  end
end
