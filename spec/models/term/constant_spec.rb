describe Constant do
  include_context 'default lets'

  describe '#unify' do
    subject { constant_A.unify(term) }

    context 'unify variable' do
      let(:term) { variable_x }
      it { expect(subject.apply term).to identify(constant_A) }
    end

    context 'unify constant' do
      context 'identify' do
        let(:term) { constant_A }
        it { is_expected.to be_kind_of(Unifier) }
      end

      context 'does not identify' do
        let(:term) { constant_B }
        it { is_expected.to be_kind_of(NonUnifier) }
      end
    end

    context 'unify function' do
      let(:term) { function_f_x }
      it { is_expected.to be_kind_of(NonUnifier) }
    end

    context 'unify unknown term' do
      let(:term) { NonUnifier }
      it { expect { subject }.to raise_error(Term::UnknownTerm) }
    end
  end
end
