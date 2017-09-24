class Formula::Binary < Formula
  attr_accessor :left, :right

  class << self
    def build(left_data, right_data)
      new.tap do |binary_formula|
        binary_formula.left, binary_formula.right = [left_data, right_data].map do |left_or_right_data|
          Formula.build left_or_right_data
        end
      end
    end
  end

  def show
    puts str
  end

  def str
    "(#{left.str} #{Formula::Binary.code} #{right.str})"
  end

  def identify?(formula)
    self.class === formula ? (formula.left.identify? left) && (formula.right.identify? right) : false
  end

  def free_variables
    [left, right].flat_map { |formula| formula.free_variables }
  end
end
