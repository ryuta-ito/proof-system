# proof_figure:
#   <deduction_1>.
#   ...
#   <deduction_n>.

require 'rules/commons/deduction'

class ProofFigure
  attr_accessor :deductions
  include Rules::Commons::Deduction

  class << self
    def build_by_file(file_path)
      new.tap do |proof_figure|
        proof_figure.deductions = Deduction.multi_build_by_file(file_path)
      end
    end
  end

  def satisfy?
    upper_proofs_satisfy?(deductions) &&
      deductions.all? { |deduction| deduction.satisfy? }
  end

  def show
    deductions.each do |deduction|
      deduction.show
    end
  end
end
