require 'models/term/util'

class Tableau
  attr_accessor :formula, :parent, :children

  include ActiveModel::Model
  include Term::Util

  class << self
    def build_by_sequent(sequent)
      series = Tableaux::Series.new( tableaux: sequent.tableaux )
      series.init
      series.first
    end

    def expantion_build_by_sequent(sequent)
      series = Tableaux::Series.new( tableaux: sequent.tableaux )
      series.init
      iterative_expantion series.first.all
      series.first
    end

    def iterative_expantion(all_tableaux)
      target_tableaux = non_expantion_tableaux(all_tableaux)

      unless target_tableaux.empty? || target_tableaux.first.satisfy?
        target_tableaux.each { |tableau| tableau.expantion }
        iterative_expantion target_tableaux.first.root.all
      end
    end

    def non_expantion_tableaux(all_tableaux)
      target_tableaux = all_tableaux.reject(&:expantioned?)
      %i(alpha_signs beta_signs delta_sign).each do |method|
        tableaux = target_tableaux.select do |tableau|
          [tableau.send(method)].flatten.any? { |sign| sign === tableau.formula }
        end
        return tableaux unless tableaux.empty?
      end
      all_tableaux.select { |tableau| tableau.gamma_sign === tableau.formula }
    end
  end

  def all
    [self] + children.flat_map { |child| child.all }
  end

  def root
    parent ? parent.root : self
  end

  def branch
    parent ? [self] + parent.branch : []
  end

  def branches
    leafs.map { |leaf| leaf.branch }
  end

  def satisfy?
    branches.all? do |branch|
      assumptions = branch.select { |tableau| Tableau::Assumption === tableau }
      consequences = branch - assumptions
      assumptions.any? do |tableau_a|
        consequences.any? do |tableau_b|
          tableau_a.formula.identify?(tableau_b.formula)
        end
      end
    end
  end

  def expantion
    @expantioned = true
    if Formula::Quantifier === formula
      leafs.each { |leaf| expantion_tableux(self).set_parent(leaf) }
    else
      leafs.each { |leaf| expantion_tableux.set_parent(leaf) }
    end
    self
  end

  def leafs
    children.empty? ? [self] : children.flat_map { |child| child.leafs }
  end

  def children
    @children || []
  end

  def expantioned?
    return false if gamma_sign === formula
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

  def constants
    formula.constants + parent_constants + children_constants
  end

  def parent_constants
    parent ? parent.formula.constants + parent.parent_constants : []
  end

  def children_constants
    children.empty? ? [] : children.flat_map { |child| child.formula.constants + child.children_constants }
  end
end
