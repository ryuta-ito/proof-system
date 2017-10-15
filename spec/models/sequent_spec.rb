describe Sequent do
  let(:sequent) { Sequent.build('{A} |- A')}

  describe '#show' do
    subject { sequent.show }
    it { expect { subject }.to output("{A} |- A\n").to_stdout }
  end
end
