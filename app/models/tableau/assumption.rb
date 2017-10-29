class Tableau
  class Assumption < Tableau
    extend Forwardable

    def_delegator :@formula, :str

    def expantion_tableux
      formula.expantion_tableux_assumption
    end
  end
end
