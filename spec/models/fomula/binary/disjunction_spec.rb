describe Disjunction do
  let(:disjunction) { Formula.build('A∨B') }

  describe '#free_variables' do
    subject { Disjunction.build(left_data, right_data).free_variables }
    let(:left_data) { 'P(x y X)' }
    let(:right_data) { 'Q(Z)' }

    it do
      is_expected.to identify_array(Formula.build(left_data).free_variables + Formula.build(right_data).free_variables)
    end
  end

  describe 'deductive_sequents_consequece' do
    subject { disjunction.deductive_sequents_consequece(sequent) }
    let(:sequent) { Sequent.build('A |- A∨B') }
    it { is_expected.to identify_array([Sequent.build('A |- A, B')]) }
  end

  describe 'deductive_sequents_consequece' do
    subject { disjunction.deductive_sequents_assumption(sequent) }
    let(:sequent) { Sequent.build('A∨B |- A∨B') }
    it { is_expected.to identify_array([Sequent.build('A |- A∨B'), Sequent.build('B |- A∨B')]) }
  end
end
