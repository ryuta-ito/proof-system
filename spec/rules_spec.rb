describe Rules do
  let(:rules) { Rules.new( name: name ) }
  let(:name) { 'name' }

  describe '#show' do
    subject { rules.show }
    it { expect { subject }.to output("(name)\n").to_stdout }
  end

  describe '#module' do
    subject { rules.module }

    context 'unkown name' do
      it { expect { subject }.to raise_error(Rules::UnknownRuleName) }
    end
  end
end
