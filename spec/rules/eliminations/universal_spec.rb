describe Rules::Eliminations::Universal do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { deduction.satisfy? }

    context 'valid' do
      let(:deduction_data) do
        <<~EOS
          {∀x.P(x)} |- ∀x.P(x)
          ------ (∀ E)
          {∀x.P(x)} |- P(C)
        EOS
      end
      it { is_expected.to be true}
    end
  end
end
