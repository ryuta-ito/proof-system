require 'models/term'

module Term::Util
  def least_constants
    constants.empty? ? [non_used_constant] : constants
  end

  def non_used_constant
    Term.build(constants.empty? ? 'A' : constants.map(&:str).sort.last.next)
  end
end
