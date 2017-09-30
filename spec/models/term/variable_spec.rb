describe Variable do
  include_context 'default lets'

  shared_examples 'unify and identify' do
    it 'identify' do
      expect(unifier.apply(variable_x)).to identify(unifier.apply(term))
    end
  end

  describe '#unify' do
    let(:unifier) { variable_x.unify(term) }

    context 'unify variable' do
      let(:term) { variable_y }
      include_examples 'unify and identify'
    end

    context 'unify constant' do
      let(:term) { constant_A }
      include_examples 'unify and identify'
    end

    context 'unify function' do
      context 'free variables is not shared' do
        let(:term) { function_f_y }
        include_examples 'unify and identify'
      end

      context 'free variables is shared' do
        let(:term) { function_f_x }
        it { expect { unifier }.to raise_error(NotImplementedError) }
      end
    end

    context 'unify unknown term' do
      let(:term) { NonUnifier }
      it { expect { unifier }.to raise_error(Term::UnknownTerm) }
    end
  end
end
