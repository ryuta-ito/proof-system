describe Rules::Introduces::Negation do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { Rules::Introduces::Negation.satisfy?(deduction) }

    context 'valid' do
      let(:deduction_data) do
        <<~EOS
          {⊥, P} |- ⊥
          ------ (¬ I)
          {⊥} |- ¬P
        EOS
      end
      it { is_expected.to be true}
    end
  end
end
