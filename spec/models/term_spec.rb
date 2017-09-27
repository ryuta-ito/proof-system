describe Term do
  describe '.build' do
    subject { Term.build(data) }

    context 'function' do
      let(:data) { 'f(x Y f(y))' }
      it { is_expected.to be_kind_of(Function) }
    end

    context 'unkown' do
      let(:data) { ')' }
      it { expect { subject }.to raise_error(Term::UnParsableTerm) }
    end
  end
end
