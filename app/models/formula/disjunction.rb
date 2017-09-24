# disjunction:
#   <formula> ∨ <formula>

class Disjunction < Formula
  attr_accessor :left, :right

  class << self
    def build(left_data, right_data)
      new.tap do |disjunction|
        disjunction.left, disjunction.right = [left_data, right_data].map do |left_or_right_data|
          super left_or_right_data
        end
      end
    end
  end

  def identify?(disjunction)
    self.class === disjunction ? (disjunction.left.identify? left) && (disjunction.right.identify? right) : false
  end

  def show
    puts str
  end

  def str
    "(#{left.str} ∧ #{right.str})"
  end
end
