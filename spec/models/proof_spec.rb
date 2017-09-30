describe Proof do
  let(:proof) { Proof.build('{A} |- A')}

  describe '#show' do
    subject { proof.show }
    it { expect { subject }.to output("{A} |- A\n").to_stdout }
  end
end
