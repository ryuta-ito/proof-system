describe Function do
  let(:variable_x) { build(:variable, str: 'x') }
  let(:variable_y) { build(:variable, str: 'y') }
  let(:constant_C) { build(:constant, str: 'C') }
  let(:function) { build(:function, arguments: arguments) }
  let(:arguments) { [variable_x, variable_y, constant_C] }

  describe '#free_variables' do
    subject { function.free_variables }

    context 'only variables' do
      let(:arguments) { [variable_x, variable_y] }
      it { is_expected.to identify_array(arguments) }
    end

    context 'only constant' do
      let(:arguments) { [constant_C] }
      it { is_expected.to identify_array([]) }
    end

    context 'mix' do
      it { is_expected.to identify_array([variable_x, variable_y]) }
    end
  end

  describe '#idenfity?' do
    subject { function.identify?(function_a) }

    context 'opponent is function instance' do
      let(:function_a) { function }
      it { is_expected.to be true }
    end

    context 'opponent is not function instance' do
      let(:function_a) { Atom.build('A') }
      it { is_expected.to be false }
    end
  end
end
