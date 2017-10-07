class Contradiction < Formula
  def self.str
    '⊥'
  end

  def str
    self.class.str
  end

  def free_variables; [] end

  def identify?(formula)
    self.class === formula
  end

  def substitute(target, replace)
    identify?(target) ? replace : self
  end

  def unify(formula)
    identify?(target) ? Unifier.build : NonUnifier.build
  end
end
