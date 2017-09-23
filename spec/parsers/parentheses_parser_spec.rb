describe ParenthesesParser do
  describe '.strip_edge_parentheses' do
    subject { ParenthesesParser.strip_edge_parentheses(data) }

    context 'success' do
      let(:data) { '(((((((asdf)))))))'}
      it { is_expected.to eq('asdf') }
    end

    context 'as it is' do
      let(:data) { '(asdf' }
      it { is_expected.to eq(data) }

      let(:data) { ')(asdf' }
      it { is_expected.to eq(data) }
    end
  end
end
