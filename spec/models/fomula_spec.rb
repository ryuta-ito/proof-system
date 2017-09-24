describe Formula do
  describe '.build' do
    subject { Formula.build(formula_data) }
    context 'imply' do
      let(:formula_data) { "A => B" }
      it { is_expected.to be_kind_of(Imply) }
    end

    context 'disjunction' do
      let(:formula_data) { 'A ∨ B' }
      it { is_expected.to be_kind_of(Disjunction) }
    end

    context 'conjunction' do
      let(:formula_data) { 'A ∧ B' }
      it { is_expected.to be_kind_of(Conjunction) }
    end
  end
end
