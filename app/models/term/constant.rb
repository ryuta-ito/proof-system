# constant: ^[a-z]\w+

class Constant < Term
  attr_accessor :str

  include ActiveModel::Model

  def self.build(constant_data)
    new( str: constant_data )
  end

  def identify?(constant)
    self.class === constant ? constant.str == str : false
  end

  def free_variables
    []
  end

  def constants
    [self]
  end

  def substitute(target, replace)
    identify?(target) ? replace : self
  end

  def unify(term)
    case term
    when Variable
      Unifier.build(self, term)
    when Constant
      identify?(term) ? Unifier.build : NonUnifier.build
    when Function
      NonUnifier.build
    else
      raise UnknownTerm, "#{term.class} is not Term class"
    end
  end
end
