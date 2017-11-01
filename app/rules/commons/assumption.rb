require 'rules/commons'

module Rules::Commons::Assumption
  def assumptions_equal?(deduction)
    deduction.upper_sequents.all? do |sequent|
      sequent.assumption.identify? deduction.lower_sequent.assumption
    end
  end
end
