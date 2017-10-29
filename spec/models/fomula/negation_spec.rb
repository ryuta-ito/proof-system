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
end
