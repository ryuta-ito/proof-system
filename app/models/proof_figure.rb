# proof_figure:
#   <deduction_1>.
#   ...
#   <deduction_n>.

require 'rules/commons/deduction'

class ProofFigure
  attr_accessor :deductions

  include ActiveModel::Model
  include Rules::Commons::Deduction

  class << self
    def build_by_file(file_path)
      new( deductions: Deduction.multi_build_by_file(file_path) )
    end

    def create_proof_figure(proof)
      proof.possible_premises
    end
  end

  def satisfy?
    upper_proofs_satisfy?(deductions) &&
      deductions.all? { |deduction| deduction.satisfy? }
  end

  def show
    deductions.each { |deduction| deduction.show }
    return
  end
end
