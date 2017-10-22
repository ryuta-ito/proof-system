describe Negation do
  let(:negation) { Formula.build('¬A') }

  describe 'deductive_sequents_consequece' do
    subject { negation.deductive_sequents_consequece(sequent) }
    let(:sequent) { Sequent.build('¬A, B |- ¬A, B') }
    it { is_expected.to identify_array([Sequent.build('¬A, B, A |- B')]) }
  end

  describe 'deductive_sequents_consequece' do
    subject { negation.deductive_sequents_axiom(sequent) }
    let(:sequent) { Sequent.build('¬A, B |- ¬A, B') }
    it { is_expected.to identify_array([Sequent.build('B |- ¬A, B, A')]) }
  end
end