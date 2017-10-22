describe Imply do
  let(:imply) { Formula.build('A=>B') }

  describe '#build' do
    subject { Imply.build(left_data, right_data) }
  end

  describe '#free_variables' do
    subject { Imply.build(left_data, right_data).free_variables }
    let(:left_data) { 'P(x y X)' }
    let(:right_data) { 'Q(Z)' }

    it do
      is_expected.to identify_array(Formula.build(left_data).free_variables + Formula.build(right_data).free_variables)
    end
  end

  describe 'deductive_sequents_consequece' do
    subject { imply.deductive_sequents_consequece(sequent) }
    let(:sequent) { Sequent.build('B |- A=>B') }
    it { is_expected.to identify_array([Sequent.build('A, B |- B')]) }
  end

  describe 'deductive_sequents_axiom' do
    subject { imply.deductive_sequents_axiom(sequent) }
    let(:sequent) { Sequent.build('A=>B, C |- A=>B') }
    it { is_expected.to identify_array([Sequent.build('C |- A=>B, A'), Sequent.build('B, C |- A=>B')]) }
  end
end
