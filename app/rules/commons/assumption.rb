require 'rules/commons'

module Rules::Commons::Assumption
  def assumptions_equal?(deduction)
    deduction.all_sequents.map do |sequent|
      sequent.assumption
    end.each_cons(2).to_a.map do |assumption_a, assumption_b|
      assumption_a.identify? assumption_b
    end.all?
  end
end
