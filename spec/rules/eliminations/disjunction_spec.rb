describe Rules::Eliminations::Disjunction do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { Rules::Eliminations::Disjunction.satisfy?(deduction) }

    context 'valid' do
      let(:deduction_data) do
        """
          {P ∨ Q, R}    |- P ∨ Q
          {P ∨ Q, R, P} |- R
          {P ∨ Q, R, Q} |- R
          ------ (∨ E)
          {P ∨ Q, R} |- R
        """
      end
      it { is_expected.to be true}
    end
  end
end
