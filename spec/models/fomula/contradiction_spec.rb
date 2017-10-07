describe Contradiction do
  let(:contradiction) { Contradiction.new }

  describe '#free_variables' do
    subject { contradiction.free_variables }
    it { is_expected.to eq([]) }
  end

  describe '#identify?' do
    subject { contradiction.identify?(formula) }

    context 'identify' do
      let(:formula) { contradiction }
      it { is_expected.to be(true) }
    end

    context 'do not identify' do
      let(:formula) { 'another' }
      it { is_expected.to be(false) }
    end
  end

  describe '#substitute' do
    subject { contradiction.substitute(target, replace) }
    let(:replace) { 'replaced' }

    context 'replace' do
      let(:target) { contradiction }
      it { is_expected.to eq(replace) }
    end

    context 'do not replace' do
      let(:target) { 'another' }
      it { is_expected.to identify(contradiction) }
    end
  end
end
