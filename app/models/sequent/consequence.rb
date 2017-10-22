# consequece:
#   Formula_1, ..., Formula_n

require 'models/formula/formulasable'

class Sequent::Consequence
  attr_accessor :formulas

  include ActiveModel::Model
  include Formulasable

  def self.build(consequece_data)
    new( formulas: Formula.multi_build(consequece_data) )
  end

  def str
    (formulas.map { |formula| ParenthesesParser.strip_edge_parentheses(formula.str) }).join(', ')
  end
end
