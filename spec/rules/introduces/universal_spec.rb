describe Rules::Introduces::Universal do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { deduction.satisfy? }

    context 'valid' do
      let(:deduction_data) do
        <<~EOS
          P |- P
          ------ (∀ I)
          P |- ∀x.P
        EOS
      end
      it { is_expected.to be true}
    end
  end
end
