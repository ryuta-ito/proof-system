# imply:
#   <formula> => <formula>

class Imply < Formula::Binary
  def self.code
    '=>'
  end

  # Γ |- Δ, A => B
  # ------
  # Γ, A |- Δ, B
  def deductive_sequents_consequence(sequent)
    [ Sequent.new( assumption: sequent.assumption.add_formula(left), consequence: sequent.consequence.substitute(self, [right]) ) ]
  end

  # Γ, A => B |- Δ
  # ------
  # Γ |- Δ, A
  # Γ, B |- Δ
  def deductive_sequents_assumption(sequent)
    [ Sequent.new( assumption: sequent.assumption.delete_formula(self), consequence: sequent.consequence.add_formula(left) ),
      Sequent.new( assumption: sequent.assumption.substitute(self, right), consequence: sequent.consequence ) ]
  end

  def expantion_tableux_consequence
    Tableaux::Series.new( tableaux: [ Tableau::Assumption.new( formula: left ), Tableau::Consequence.new( formula: right ) ])
  end

  def expantion_tableux_assumption
    Tableaux::Parallel.new( tableaux: [ Tableau::Consequence.new( formula: left ), Tableau::Assumption.new( formula: right ) ])
  end
end
