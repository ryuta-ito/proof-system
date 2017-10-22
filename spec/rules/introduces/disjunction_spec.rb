describe Rules::Introduces::Disjunction do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { Rules::Introduces::Disjunction.satisfy?(deduction) }

    context 'valid' do
      let(:deduction_data) do
        """
          A |- A
          ------ (∨ I)
          A |- A ∨ B
        """
      end
      it { is_expected.to be true}
    end
  end
end
