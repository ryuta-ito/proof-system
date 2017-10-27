describe Conjunction do
  include_context 'default lets'
  let(:conjunction) { Formula.build('P(x)∧A') }

  describe '#free_variables' do
    subject { Conjunction.build(left_data, right_data).free_variables }
    let(:left_data) { '∃x.P(x y X)' }
    let(:right_data) { '∀z.Q(Z)' }

    it do
      is_expected.to identify_array(Formula.build(left_data).free_variables + Formula.build(right_data).free_variables)
    end
  end

  describe '#substitute' do
    subject { conjunction.substitute(target, replace) }

    context 'P(x)∧A[A/x]' do
      let(:target) { variable_x }
      let(:replace) { constant_A }
      it { is_expected.to identify(Formula.build 'P(A)∧A') }
    end
  end

  describe '#show' do
    subject { conjunction.show }
    it { expect { subject }.to output("(P(x) ∧ A)\n").to_stdout }
  end

  describe 'deductive_sequents_consequece' do
    subject { conjunction.deductive_sequents_consequece(sequent) }
    let(:conjunction) { Formula.build('A∧B') }
    let(:sequent) { Sequent.build('A, B |- A∧B') }
    it { is_expected.to identify_array([Sequent.build('A, B |- A'), Sequent.build('A, B |- B')]) }
  end

  describe 'deductive_sequents_assumption' do
    subject { conjunction.deductive_sequents_assumption(sequent) }
    let(:conjunction) { Formula.build('A∧B') }
    let(:sequent) { Sequent.build('A∧B |- A') }
    it { is_expected.to identify_array([Sequent.build('A, B |- A')]) }
  end
end
