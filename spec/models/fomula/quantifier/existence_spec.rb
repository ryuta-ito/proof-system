describe Existence do
  include_context 'default lets'
  let(:existence) { Existence.build('∃x.P(x y)') }

  describe '#substitute' do
    subject { existence.substitute(target, replace) }

    context '∃x.P(x y)[A/x]' do
      let(:target) { variable_x }
      let(:replace) { constant_A }
      it { is_expected.to identify(Existence.build '∃x.P(x y)') }
    end

    context '∃x.P(x y)[A/y]' do
      let(:target) { variable_y }
      let(:replace) { constant_A }
      it { is_expected.to identify(Existence.build '∃x.P(x A)') }
    end

    context '∃x.P(x y)[x/y]' do
      let(:target) { variable_y }
      let(:replace) { variable_x }
      it { expect { subject }.to raise_error Formula::Quantifier::ReplaceDataBounded }
    end
  end

  describe '#show' do
    subject { existence.show }
    it { expect { subject }.to output("∃x.P(x y)\n").to_stdout }
  end

  describe '#deductive_sequents_assumption' do
    subject { existence.deductive_sequents_assumption(sequent).first }

    context 'no constants' do
      let(:sequent) { Sequent.build('∃x.P(x y) |- ∃x.P(x y)') }
      it { is_expected.to identify(Sequent.build('P(A y) |- ∃x.P(x y)'))}
    end

    context 'exist constants' do
      let(:sequent) { Sequent.build('∃x.P(x y) |- ∃x.P(x B)') }
      it { is_expected.to identify(Sequent.build('P(C y) |- ∃x.P(x B)'))}
    end
  end

  describe '#deductive_sequents_consequece' do
    subject { existence.deductive_sequents_consequece(sequent).first }

    context 'no constants' do
      let(:sequent) { Sequent.build('∃x.P(x y) |- ∃x.P(x y)') }
      it { is_expected.to identify(Sequent.build('∃x.P(x y) |- ∃x.P(x y), P(A y)'))}
    end

    context 'exist constants' do
      let(:sequent) { Sequent.build('P(A B) |- ∃x.P(x y)') }
      it { is_expected.to identify(Sequent.build('P(A B) |- ∃x.P(x y), P(A y), P(B y)'))}
    end
  end
end
