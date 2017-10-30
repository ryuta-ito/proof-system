require 'models/term'

module Term::Util
  def least_constants
    constants.empty? ? [non_used_constant] : uniq_constants
  end

  def non_used_constant
    Term.build(constants.empty? ? 'A' : constants.map(&:str).sort.last.next)
  end

  def uniq_constants
    uniq(constants)
  end

  def uniq(constants)
    if constants.empty?
      []
    else
      [constants.first] +
        uniq(constants.reject { |constant| constants.first.identify?(constant) })
    end
  end
end
