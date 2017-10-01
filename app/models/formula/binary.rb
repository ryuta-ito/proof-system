class Formula::Binary < Formula
  attr_accessor :left, :right, :code

  class << self
    def build(left_data, right_data)
      new.tap do |binary_formula|
        binary_formula.code = code
        binary_formula.left, binary_formula.right = [left_data, right_data].map do |left_or_right_data|
          Formula.build left_or_right_data
        end
      end
    end
  end

  def str
    "(#{left.str} #{code} #{right.str})"
  end

  def identify?(formula)
    self.class === formula ? (formula.left.identify? left) && (formula.right.identify? right) : false
  end

  def free_variables
    [left, right].flat_map { |formula| formula.free_variables }
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
end
