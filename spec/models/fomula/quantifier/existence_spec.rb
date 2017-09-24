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
end
