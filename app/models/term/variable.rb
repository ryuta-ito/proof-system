# variable: ^[A-Z]\w+

class Variable < Term
  attr_accessor :str

  include ActiveModel::Model

  def self.build(variable_data)
    new( str: variable_data )
  end

  def identify?(variable)
    self.class === variable ? variable.str == str : false
  end

  def free_variables
    [self]
  end

  def substitute(target, replace)
    identify?(target) ? replace : self
  end

  def unify(term)
    return Unifier.build if identify?(term)

    case term
    when Variable, Constant
      Unifier.build(term, self)
    when Function
      if term.free_variables.any?{ |free_variable| identify?(free_variable) }
        raise NotImplementedError, 'non permit situation free variables is shared'
      else
        Unifier.build(term, self)
      end
    else
      raise UnknownTerm, "#{term.class} is not Term class"
    end
  end
end
