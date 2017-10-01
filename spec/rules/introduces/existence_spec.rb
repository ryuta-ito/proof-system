describe Rules::Introduces::Existence do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { deduction.satisfy? }

    context 'valid' do
      context 'atom' do
        let(:deduction_data) do
          <<~EOS
            {P(A)} |- P(A)
            ------ (∃ I)
            {P(A)} |- ∃x.P(x)
          EOS
        end
        it { is_expected.to be true}
      end

      context 'binary formula' do
        let(:deduction_data) do
          <<~EOS
            {P(A)∧B} |- P(A)∧B
            ------ (∃ I)
            {P(A)∧B} |- ∃x.(P(x)∧B)
          EOS
        end
        it { is_expected.to be true}
      end

      context 'quantifier formula' do
        let(:deduction_data) do
          <<~EOS
            {∀x.P(x A)} |- ∀x.P(x A)
            ------ (∃ I)
            {∀x.P(x A)} |- ∃y.(∀x.P(x y))
          EOS
        end
        it { is_expected.to be true}
      end
    end

    context 'invalid' do
      let(:deduction_data) do
        <<~EOS
          {P(x)} |- P(x)
          ------ (∃ I)
          {P(x)} |- ∃x.P(A)
        EOS
      end
      it { is_expected.to be false}
    end
  end
end
