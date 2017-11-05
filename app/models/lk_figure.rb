class LkFigure
  attr_accessor :root_sequent

  include ActiveModel::Model

  def self.build_by_file(file_path)
    new root_sequent: Sequent.build_by_figure(FileConnector.read file_path)
  end

  def show
    root_sequent.show_lk_proof_figure
  end
end
