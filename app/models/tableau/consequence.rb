class Tableau
  class Consequence < Tableau
    def expantion_tableux
      formula.expantion_tableux_consequence
    end

    def str
      "> #{formula.str}"
    end
  end
end
