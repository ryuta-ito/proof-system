# disjunction:
#   <formula> ∨ <formula>

class Disjunction < Formula
  attr_accessor :left, :right

  class << self
    def build(disjunction_data)
      new.tap do |disjunction|
        disjunction.left, disjunction.right = parse_disjunction(disjunction_data).map do |left_or_right_data|
          super left_or_right_data
        end
      end
    end

    private

    def parse_disjunciton(disjunction_data)
      disjunction_data.split('∨', 2).map { |left_or_right_data| left_or_right_data.strip}
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
