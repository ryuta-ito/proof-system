describe Sequent do
  include_context 'default lets'
  let(:sequent) { Sequent.build('A |- A')}

  describe '#show' do
    subject { sequent.show }
    it { expect { subject }.to output("A |- A\n").to_stdout }
  end

  describe '#show_lk_proof_figure' do
    subject { sequent.show_lk_proof_figure }

    context 'contraposition' do
      let(:sequent) { Sequent.build('A => B |- ¬B => ¬A') }
      it { expect { subject }.to output(contraposition_sequent_figure).to_stdout }
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

    context 'proposition example (duplicated)' do
      let(:sequent) { Sequent.build('A, A |- A') }
      let(:proof_figure) do
        <<~EOS
          A |- A
          ------ (C)
          A, A |- A
        EOS
      end
      it { expect { subject }.to output(proof_figure).to_stdout }
    end

    context 'universal quantifier example' do
      let(:sequent) { Sequent.build('∀x.P(x) ∨ Q |- ∀y.(P(y) ∨ Q)') }
      it { expect { subject }.to output(universal_quantifier_sequent_figure_1).to_stdout }
    end
  end
end
