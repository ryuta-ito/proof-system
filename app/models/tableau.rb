class Tableau
  attr_accessor :formula, :parent, :children

  include ActiveModel::Model

  class << self
    def expantion_build_by_sequent(sequent)
      series = Tableaux::Series.new( tableaux: sequent.tableaux )
      series.init
      iterative_expantion series.first
      series.first
    end

    def iterative_expantion(tableau)
      tableau.expantion unless tableau.expantioned?
      tableau.children.each { |child| iterative_expantion child }
    end
  end

  def expantion
    @expantioned = true
    leafs.each { |leaf| expantion_tableux.set_parent(leaf) }
    self
  end

  def leafs
    children.empty? ? [self] : children.flat_map { |child| child.leafs }
  end

  def children
    @children || []
  end

  def expantioned?
    (Atom === formula) || @expantioned
  end

  def show(tab_base='')
    puts "#{tab_base}#{ParenthesesParser.strip_edge_parentheses str}"

    children.reverse.each_with_index.map do |child, index|
      [child, '  ' * (children.size - index - 1)]
    end.each do |child, tab|
      child.show(tab_base + tab)
    end; nil
  end

  def identify?(tableau)
    formula.identify? tableau.formula
  end
end
