describe Rules::Eliminations::Existence do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { deduction.satisfy? }

    context 'valid' do
      let(:deduction_data) do
        <<~EOS
          ∃x.P(x), Q |- ∃x.P(x)
            ∃x.P(x), Q, P(x) |- Q
          ------ (∃ E)
          ∃x.P(x), Q |- Q
        EOS
      end
      it { is_expected.to be true}
    end
  end
end
