# imply:
#   <formula> => <formula>

class Imply < Formula
  attr_accessor :left, :right

  class << self
    def build(imply_data)
      new.tap do |imply|
        imply.left, imply.right = parse_imply(imply_data).map do |left_or_right_data|
          super left_or_right_data
        end
      end
    end

    private

    def parse_imply(imply_data)
      imply_data.split('=>', 2).map {|left_or_right| left_or_right.strip}
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
