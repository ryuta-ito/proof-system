require 'rules/commons'

module Rules::Commons::Deduction
  def upper_sequents_satisfy?(deductions)
    not_obvious_deductions = deductions.select { |deduction| !deduction.obvious? }
    not_obvious_deductions.all? do |deduction|
      not_obvious_upper_sequents = deduction.upper_sequents.select { |sequent| !sequent.obvious? }
      not_obvious_upper_sequents.all? do |upper_sequent|
        (deductions - [deduction]).any? do |other_deduction|
          upper_sequent.axiom.identify?(other_deduction.lower_sequent.axiom) &&
            upper_sequent.theorem.identify?(other_deduction.lower_sequent.theorem)
        end
      end
    end
  end
end
