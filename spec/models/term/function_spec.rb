describe Function do
  let(:variable_x) { build(:variable, str: 'x') }
  let(:function) { build(:function, arguments: [variable_x]) }

  describe '#free_variables' do
    subject { function.free_variables.first }
    it { is_expected.to identify(variable_x) }
  end
end
