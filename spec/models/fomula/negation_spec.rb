describe Negation do
  let(:negation) { Formula.build('¬A') }

  describe 'deductive_sequents_consequence' do
    subject { negation.deductive_sequents_consequence(sequent) }
    let(:sequent) { Sequent.build('¬A, B |- ¬A, B') }
    it { is_expected.to identify_array([Sequent.build('¬A, B, A |- B')]) }
  end

  describe 'deductive_sequents_consequence' do
    subject { negation.deductive_sequents_assumption(sequent) }
    let(:sequent) { Sequent.build('¬A, B |- ¬A, B') }
    it { is_expected.to identify_array([Sequent.build('B |- ¬A, B, A')]) }
  end

  shared_examples 'formula variation' do
    context 'imply' do
      let(:negation) { Formula.build('¬(A=>B)') }
      it { is_expected.to identify(Formula.build('A∧¬B')) }
    end

    context 'negation' do
      let(:negation) { Formula.build('¬¬A') }
      it { is_expected.to identify(Formula.build('A')) }
    end

    context 'conjunction' do
      let(:negation) { Formula.build('¬(A∧B)') }
      it { is_expected.to identify(Formula.build('¬A∨¬B')) }
    end

    context 'disjunction' do
      let(:negation) { Formula.build('¬(A∨B)') }
      it { is_expected.to identify(Formula.build('¬A∧¬B')) }
    end
  end

  describe '#disjunctive_normal' do
    subject { negation.disjunctive_normal }
    include_examples 'formula variation'
  end

  describe '#conjunctive_normal' do
    subject { negation.conjunctive_normal }
    include_examples 'formula variation'
  end
end
