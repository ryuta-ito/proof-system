# sequent_figure:
#   <deduction_1>.
#   ...
#   <deduction_n>.

class NkFigure
  attr_accessor :root_deduction

  include ActiveModel::Model
  extend Forwardable

  def_delegators :root_deduction, :show, :satisfy?

  class << self
    def build_by_file(file_path)
      new( root_deduction: Deduction.multi_build_by_file(file_path) )
    end
  end
end
