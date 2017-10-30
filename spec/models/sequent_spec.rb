describe Sequent do
  let(:sequent) { Sequent.build('A |- A')}

  describe '#show' do
    subject { sequent.show }
    it { expect { subject }.to output("A |- A\n").to_stdout }
  end

  describe '#show_lk_proof_figure' do
    subject { sequent.show_lk_proof_figure }

    context 'contraposition' do
      let(:sequent) { Sequent.build('A => B |- ¬B => ¬A') }
      let(:proof_figure) do
        <<~EOS
          A |- A
          ------ (W R)
          A |- B, A
              B |- B
              ------ (W L)
              B, A |- B
          ------ (=> L)
          A => B, A |- B
          ------ (¬ R)
          A => B |- ¬A, B
          ------ (¬ L)
          A => B, ¬B |- ¬A
          ------ (=> R)
          A => B |- ¬B => ¬A
        EOS
      end
      it { expect { subject }.to output(proof_figure).to_stdout }
    end

    context 'proposition example (invalid)' do
      let(:sequent) { Sequent.build('A ∨ B |- A ∧ B') }
      let(:proof_figure) do
        <<~EOS
          A |- A
              A |- B
          ------ (∧ R)
          A |- A ∧ B
              B |- A
                  B |- B
              ------ (∧ R)
              B |- A ∧ B
          ------ (∨ L)
          A ∨ B |- A ∧ B
        EOS
      end
      it { expect { subject }.to output(proof_figure).to_stdout }
    end

    context 'universal quantifier example' do
      let(:sequent) { Sequent.build('∀x.P(x) ∨ Q |- ∀y.(P(y) ∨ Q)') }
      let(:proof_figure) do
        <<~EOS
          P(A) |- P(A)
          ------ (W R)
          P(A) |- P(A), Q
          ------ (W L)
          ∀x.P(x), P(A) |- P(A), Q
          ------ (∀ L)
          ∀x.P(x) |- P(A), Q
          ------ (∨ R)
          ∀x.P(x) |- P(A) ∨ Q
          ------ (∀ R)
          ∀x.P(x) |- ∀y.(P(y) ∨ Q)
              Q |- Q
              ------ (W R)
              Q |- P(A), Q
              ------ (∨ R)
              Q |- P(A) ∨ Q
              ------ (∀ R)
              Q |- ∀y.(P(y) ∨ Q)
          ------ (∨ L)
          ∀x.P(x) ∨ Q |- ∀y.(P(y) ∨ Q)
        EOS
      end
      it { expect { subject }.to output(proof_figure).to_stdout }
    end
  end
end
