# constant: ^[a-z]\w+

class Constant < Term
  attr_accessor :str

  def self.build(constant_data)
    new.tap do |constant|
      constant.str = constant_data
    end
  end

  def identify?(constant)
    self.class === constant ? constant.str == str : false
  end
end
