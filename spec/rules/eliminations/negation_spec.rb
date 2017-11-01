describe Rules::Eliminations::Negation do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { Rules::Eliminations::Negation.satisfy?(deduction) }

    context 'valid' do
      let(:deduction_data) do
        <<~EOS
          P, ¬P |- P
            P, ¬P |- ¬P
          ------ (¬ E)
          P, ¬P |- ⊥
        EOS
      end
      it { is_expected.to be true}
    end
  end
end
