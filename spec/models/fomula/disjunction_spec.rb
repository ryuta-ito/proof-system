describe Disjunction do
  describe '#free_variables' do
    subject { Disjunction.build(left_data, right_data).free_variables }
    let(:left_data) { 'P(x y X)' }
    let(:right_data) { 'Q(Z)' }

    it do
      is_expected.to identify_array(Formula.build(left_data).free_variables + Formula.build(right_data).free_variables)
    end
  end
end