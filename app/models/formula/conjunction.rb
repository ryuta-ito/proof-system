# conjunction:
#   <formula> ∧ <formula>

class Conjunction < Formula
  attr_accessor :left, :right

  class << self
    def build(conjunction_data)
      new.tap do |conjunction|
        conjunction.left, conjunction.right = parse_conjunction(conjunction_data).map do |left_or_right_data|
          super left_or_right_data
        end
      end
    end

    private

    def parse_conjunction(conjunction_data)
      conjunction_data.split('∧', 2).map { |left_or_right_data| left_or_right_data.strip}
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
