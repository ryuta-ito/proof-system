class Tableaux
  attr_accessor :tableaux

  include ActiveModel::Model

  class Series < Tableaux
    extend Forwardable
    def_delegator :@tableaux, :first

    def init
      tableaux.reduce { |result, series| result.children = [series]; series }
      tableaux.reverse.reduce { |result, series| result.parent = series }
    end

    def set_parent(tableau)
      ([tableau] + tableaux).reverse.reduce { |result, series| result.parent = series }
      tableaux.reduce([tableau]) { |result, series| result.first.children = [series] }
    end
  end

  class Parallel < Tableaux
    def set_parent(target_tableau)
      tableaux.each { |tableau| tableau.parent = target_tableau }
      target_tableau.children = tableaux
    end
  end
end
