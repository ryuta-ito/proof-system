describe ProofFigure do
  let(:proof_figure) { ProofFigure.build_by_file('dummy_file_path') }
  let(:proof_figure_data) do
    <<~EOS
      {A => B, C => A, C} |- C => A
      {A => B, C => A, C} |- C
      ------ (=> E)
      {A => B, C => A, C} |- A.
      {A => B, C => A, C} |- A => B
      {A => B, C => A, C} |- A
      ------ (=> E)
      {A => B, C => A, C} |- B.
      {A => B, C => A, C} |- B
      ------ (=> I)
      {A => B, C => A} |- C => B.
      {A => B, C => A} |- C => B
      ------ (=> I)
      {A => B} |- (C => A) => (C => B).
      {A => B} |- (C => A) => (C => B)
      ------ (=> I)
      {} |- (A => B) => ((C => A) => (C => B)).
    EOS
  end
  include_context 'use File.read mock'
  let(:file_connector_read_text) { proof_figure_data }

  describe '.satisfy?' do
    subject { proof_figure.satisfy? }

    context 'valid' do
      it { is_expected.to be true }
    end
  end

  describe '#show' do
    subject { proof_figure.show }
    it { expect { subject }.to output(proof_figure_data).to_stdout }
  end
end
