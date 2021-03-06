describe Rules::Eliminations::Conjunction do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { Rules::Eliminations::Conjunction.satisfy?(deduction) }

    context 'valid' do
      let(:deduction_data) do
        <<~EOS
          A ∧ B |- A ∧ B
          ------ (∧ E)
          A ∧ B |- A
        EOS
      end
      it { is_expected.to be true}
    end
  end
end
