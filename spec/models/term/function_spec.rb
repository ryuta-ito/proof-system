describe Function do
  include_context 'default lets'
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

  describe '#substitute' do
    subject { function.substitute(target, replace) }

    context 'f(x)[A/x]' do
      let(:arguments) { [variable_x] }
      let(:target) { variable_x }
      let(:replace) { constant_A }
      it { is_expected.to identify(Function.build 'f(A)') }
    end
  end

  describe '#unify' do
    subject { function.unify(target_term) }

    shared_examples 'unify and identify' do
      it 'apply unifier and then identify' do
        expect(subject.apply(function)).to identify(subject.apply(target_term))
      end
    end

    context 'unify constant' do
      let(:target_term) { constant_A }
      it { is_expected.to be_kind_of(NonUnifier) }
    end

    context 'unify variable' do
      context 'shared free variables exist' do
        let(:target_term) { variable_x }
        it { expect { subject }.to raise_error(NotImplementedError) }
      end

      context 'shared free variables do not exist' do
        let(:target_term) { variable_z }
        include_examples 'unify and identify'
      end
    end

    context 'unify function' do
      context 'function_name is not same' do
        let(:target_term) { function_g_x }
        it { is_expected.to be_kind_of(NonUnifier) }
      end

      context 'arguments size is not same' do
        let(:target_term) { function_f_x }
        it { is_expected.to be_kind_of(NonUnifier) }
      end

      context 'arguments size and function_name are same' do
        let(:target_term) { build(:function, arguments: [constant_A, constant_B, variable_z]) }

        context 'simple unify' do
          include_examples 'unify and identify'
        end

        context 'include non unify' do
          let(:arguments) { [constant_B, variable_y, constant_C] }
          it { is_expected.to be_kind_of(NonUnifier) }
        end
      end
    end
  end
end
