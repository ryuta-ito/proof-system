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
end
