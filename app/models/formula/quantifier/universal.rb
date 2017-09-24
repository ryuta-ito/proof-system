# existence:
#   ∀<bounded_variable>.<formula>

class Universal < Formula::Quantifier
  def self.code
    '∀'
  end
end
