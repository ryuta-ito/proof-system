describe StateBase do
  describe '#next_state' do
    subject { StateBase.new.next_state('dummy_input') }

    it { expect { subject }.to raise_error NotImplementedError }
  end
end
