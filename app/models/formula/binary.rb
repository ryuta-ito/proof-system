class Formula::Binary < Formula
  attr_accessor :left, :right

  include ActiveModel::Model

  class << self
    def build(left_data, right_data)
      new( left: Formula.build(left_data),
           right: Formula.build(right_data) )
    end
  end

  def code
    self.class.code
  end

  def str
    "(#{left.str} #{code} #{right.str})"
  end

  def identify?(formula)
    self.class === formula ? (formula.left.identify? left) && (formula.right.identify? right) : false
  end

  def free_variables
    [left, right].flat_map &:free_variables
  end

  def constants
    [left, right].flat_map &:constants
  end

  def substitute(target, replace)
    if identify?(target)
      replace
    else
      substituted_left = left.substitute(target, replace)
      substituted_right = right.substitute(target, replace)
      self.class.build(substituted_left.str, substituted_right.str)
    end
  end

  def unify(target_formula)
    return NonUnifier.build unless self.class === target_formula

    [left, right].zip([target_formula.left, target_formula.right]).reduce(Unifier.build) do |unifier, (formula_a, formula_b)|
      unifier.compose formula_a.unify(formula_b)
    end
  end

  def clauses
    if self.class === left and self.class === right
      left.clauses + right.clauses
    elsif self.class === left and !(self.class === right)
      left.clauses + [right]
    elsif !(self.class === left) and self.class === right
      [left] + right.clauses
    else
      [left, right]
    end
  end

  def flat
    clauses.reverse.reduce do |clause_a, clause_b|
      self.class.new left: clause_b, right: clause_a
    end
  end
end
