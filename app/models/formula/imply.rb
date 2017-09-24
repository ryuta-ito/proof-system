# imply:
#   <formula> => <formula>

class Imply < Formula
  attr_accessor :left, :right

  class << self
    def build(left_data, right_data)
      new.tap do |imply|
        imply.left, imply.right = [left_data, right_data].map do |left_or_right_data|
          super left_or_right_data
        end
      end
    end
  end

  def identify?(imply)
    self.class === imply ? (imply.left.identify? left) && (imply.right.identify? right) : false
  end

  def show
    puts str
  end

  def str
    "(#{left.str} => #{right.str})"
  end
end
