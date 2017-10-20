# sequent_figure:
#   <deduction_1>.
#   ...
#   <deduction_n>.

require 'rules/commons/deduction'

class SequentFigure
  attr_accessor :deductions

  include ActiveModel::Model
  include Rules::Commons::Deduction

  class << self
    def build_by_file(file_path)
      new( deductions: Deduction.multi_build_by_file(file_path) )
    end
  end

  def satisfy?
    upper_sequents_satisfy?(deductions) &&
      deductions.all? { |deduction| deduction.satisfy? }
  end

  def show
    deductions.each { |deduction| deduction.show }; nil
  end
end
