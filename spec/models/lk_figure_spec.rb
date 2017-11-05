describe LkFigure do
  include_context 'default lets'

  describe '#show' do
    subject { sequent.show }
    let(:sequent) { LkFigure.build_by_file('dummy_file_path') }

    include_context 'use File.read mock'
    let(:file_connector_read_text) { contraposition_sequent_figure }
    it { expect { subject }.to output(contraposition_sequent_figure).to_stdout }
  end
end
