describe Rules::Introduces::Conjunction do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { Rules::Introduces::Conjunction.satisfy?(deduction) }

    context 'valid' do
      let(:deduction_data) do
        """
          {A, B} |- A
          {A, B} |- B
          ------ (∧ I)
          {A, B} |- A ∧ B
        """
      end
      it { is_expected.to be true}
    end
  end
end
