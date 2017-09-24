describe Conjunction do
  let(:imply_data) { "#{left_data}∧#{right_data}"}

  describe '#free_variables' do
    subject { Conjunction.build(left_data, right_data).free_variables }
    let(:left_data) { 'P(x y X)' }
    let(:right_data) { 'Q(Z)' }

    it do
      is_expected.to identify_array(Formula.build(left_data).free_variables + Formula.build(right_data).free_variables)
    end
  end
end
