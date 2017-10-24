describe Sequent do
  let(:sequent) { Sequent.build('A |- A')}

  describe '#show' do
    subject { sequent.show }
    it { expect { subject }.to output("A |- A\n").to_stdout }
  end

  describe '#show_lk_proof_figure' do
    subject { sequent.show_lk_proof_figure }
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
end
