# existence:
#   ∃<bounded_variable>.<formula>

class Existence < Formula::Quantifier
  def self.code
    '∃'
  end
end
