# variable: ^[A-Z]\w+

class Variable < Term
  attr_accessor :str

  def self.build(variable_data)
    new.tap do |variable|
      variable.str = variable_data
    end
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
end
