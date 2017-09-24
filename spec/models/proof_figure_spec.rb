describe ProofFigure do
  let(:proof_figure) { ProofFigure.build_by_file('dummy_file_path') }

  describe '.satisfy?' do
    subject { proof_figure.satisfy? }
    include_context 'use File.read mock'

    context 'valid' do
      let(:file_connector_read_text) do
        """ {A => B, C => A, C} |- C => A
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
            {} |- (A => B) => ((C => A) => (C => B))."""
      end
      it { is_expected.to be true }
    end
  end
end
