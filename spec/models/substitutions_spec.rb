describe Substitutions do
  include_context 'default lets'

  describe '#compose' do
    subject { substitutions.compose(target_substitutions).apply(target_term) }
    let(:substitutions) { Substitutions.new([substitution_A_x]) }

    context 'compose empty substitutions' do
      context 'target substitution is empty' do
        let(:target_substitutions) { Substitutions.new([]) }
        let(:target_term) { variable_x }
        it { is_expected.to identify(constant_A) }
      end

      context 'receiver substitutions is empty' do
        let(:substitutions) { Substitutions.new([]) }
        let(:target_substitutions) { Substitutions.new([substitution_A_x]) }
        let(:target_term) { variable_x }
        it { is_expected.to identify(constant_A) }
      end
    end

    context 'compose only non belong substitutions' do
      let(:target_substitutions) { Substitutions.new([substitution_A_y]) }
      let(:target_term) { function_f_x_y }
      it do
        expect(substitutions.compose(target_substitutions).substitutions.size).to eq(2)
        is_expected.to identify(function_f_A_A)
      end
    end

    context 'compose only belong substitutions' do
      let(:target_substitutions) { Substitutions.new([substitution_B_x]) }
      let(:target_term) { variable_x }
      it do
        expect(substitutions.compose(target_substitutions).substitutions.size).to eq(1)
        is_expected.to identify(constant_A)
      end
    end

    context 'compose belong and non belong substitutions' do
      let(:target_substitutions) { Substitutions.new([substitution_B_x, substitution_A_y]) }
      let(:target_term) { function_f_x_y }
      it do
        expect(substitutions.compose(target_substitutions).substitutions.size).to eq(2)
        is_expected.to identify(function_f_A_A)
      end
    end
  end

  describe Substitutions::Substitution do
    describe '#show' do
      subject { substitution.show }
      let(:substitution) { substitution_A_x }

      it { expect { subject }.to output("[A/x]\n").to_stdout }
    end

    describe '#compose' do
      subject { substitution.compose(substitutions).apply(target_term) }

      context 'single substitution apply(no shared free variables)' do
        let(:substitution) { Substitutions::Substitution.new(function_f_y, variable_x) }
        let(:substitutions) { Substitutions.new([substitution_A_y]) }
        let(:target_term) { variable_x }

        it { is_expected.to identify(function_f_A) }
      end
    end
  end
end
