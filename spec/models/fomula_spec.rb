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

  describe '#constants' do
    include_context 'default lets'
    subject { Formula.build('¬P(f(A)) ∨ ∀x.Q(B) ∨ ⊥').constants }
    it { is_expected.to identify_array([constant_A, constant_B]) }
  end

  describe '#disjunctive_normal' do
    subject { formula.disjunctive_normal.flat }
    let(:formula) { Formula.build('(A∨D)∧((B=>¬E)∨C)') }
    it { is_expected.to identify(Formula.build('(A ∧ ¬B) ∨ ((A ∧ ¬E) ∨ ((D ∧ ¬B) ∨ ((D ∧ ¬E) ∨ ((A ∧ C) ∨ (D ∧ C)))))')) }
  end

  describe '#conjunctive_normal' do
    subject { formula.conjunctive_normal.flat }
    let(:formula) { Formula.build('(A∧D)∨((B=>¬E)∧C)') }
    it { is_expected.to identify(Formula.build('A ∧ ((¬B ∨ ¬E) ∧ (D ∧ ((¬B ∨ ¬E) ∧ ((A ∨ C) ∧ (D ∨ C)))))')) }
  end
end
