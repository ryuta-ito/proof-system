# sequent_figure:
#   <deduction_1>.
#   ...
#   <deduction_n>.

require 'rules/commons/deduction'

class NkFigure
  attr_accessor :root_deduction

  include ActiveModel::Model
  include Rules::Commons::Deduction
  extend Forwardable

  def_delegators :root_deduction, :show, :satisfy?

  class << self
    def build_by_file(file_path)
      new( root_deduction: Deduction.multi_build_by_file(file_path) )
    end
  end
end
