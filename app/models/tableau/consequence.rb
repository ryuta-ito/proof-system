class Tableau
  class Consequence < Tableau
    include Sign::Consequence

    def expantion_tableux(*tableau)
      formula.expantion_tableux_consequence(*tableau)
    end

    def str
      "> #{formula.str}"
    end
  end
end
