describe SequentFigure do
  let(:sequent_figure) { SequentFigure.build_by_file('dummy_file_path') }
  let(:sequent_figure_data) do
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
  let(:file_connector_read_text) { sequent_figure_data }

  describe '.satisfy?' do
    subject { sequent_figure.satisfy? }

    context 'valid' do
      it { is_expected.to be true }
    end

    context '∀x.P(x) ∨ Q => ∀y.(P(y) ∨ Q)' do
      let(:sequent_figure_data) do
        <<~EOS
          {∀x.P(x) ∨ Q, ∀x.P(x)} |- ∀x.P(x)
          ------ (∀ E)
          {∀x.P(x) ∨ Q, ∀x.P(x)} |- P(y).

          {∀x.P(x) ∨ Q, ∀x.P(x)} |- P(y)
          ------ (∨ I)
          {∀x.P(x) ∨ Q, ∀x.P(x)} |- P(y) ∨ Q.

          {∀x.P(x) ∨ Q, Q} |- Q
          ------ (∨ I)
          {∀x.P(x) ∨ Q, Q} |- P(y) ∨ Q.

          {∀x.P(x) ∨ Q} |- ∀x.P(x) ∨ Q
          {∀x.P(x) ∨ Q, ∀x.P(x)} |- P(y) ∨ Q
          {∀x.P(x) ∨ Q, Q} |- P(y) ∨ Q
          ------ (∨ E)
          {∀x.P(x) ∨ Q} |- P(y) ∨ Q.

          {∀x.P(x) ∨ Q} |- P(y) ∨ Q
          ------ (∀ I)
          {∀x.P(x) ∨ Q} |- ∀y.(P(y) ∨ Q).

          {∀x.P(x) ∨ Q} |- ∀y.(P(y) ∨ Q)
          ------ (=> I)
          {} |- ∀x.P(x) ∨ Q => ∀y.(P(y) ∨ Q).
        EOS
      end
      it { is_expected.to be true }
    end
  end

  describe '#show' do
    subject { sequent_figure.show }
    it { expect { subject }.to output(sequent_figure_data).to_stdout }
  end
end
