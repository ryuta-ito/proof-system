class Tableau
  class Assumption < Tableau
    include Sign::Assumption
    extend Forwardable

    def_delegator :@formula, :str

    def expantion_tableux(*tableau)
      formula.expantion_tableux_assumption(*tableau)
    end
  end
end
