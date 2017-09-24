# conjunction:
#   <formula> ∧ <formula>

class Conjunction < Formula
  attr_accessor :left, :right

  class << self
    def build(left_data, right_data)
      new.tap do |conjunction|
        conjunction.left, conjunction.right = [left_data, right_data].map do |left_or_right_data|
          super left_or_right_data
        end
      end
    end
  end

  def identify?(conjunction)
    self.class === conjunction ? (conjunction.left.identify? left) && (conjunction.right.identify? right) : false
  end

  def show
    puts str
  end

  def str
    "(#{left.str} ∧ #{right.str})"
  end
end
