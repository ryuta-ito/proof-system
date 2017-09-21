require 'rules/commons'

module Rules::Commons::Deduction
  def upper_proofs_satisfy?(deductions)
    not_obvious_deductions = deductions.select { |deduction| !deduction.obvious? }

    not_obvious_deductions.all? do |deduction|
      deduction.upper_proofs.all? do |upper_proof|
        (deductions - [deduction]).any? do |other_deduction|
          upper_proof.axiom.identify?(other_deduction.lower_proof.axiom) &&
            upper_proof.theorem.identify?(other_deduction.lower_proof.theorem)
        end
      end
    end
  end
end
