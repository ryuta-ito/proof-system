describe FormulaParser do
  let(:data) { "#{left_data}#{right_data}" }
  let(:divided_data) { [left_data, right_data, result] }

  describe '#divide' do
    subject { FormulaParser.split_divide(data) }

    context 'accepted' do
      [
        ['B(y)', '∨ φ(x)', :accepted]
      ].each do |left_data, right_data, result|
        let(:left_data) { left_data }
        let(:right_data) { right_data }
        let(:result) { result }
        it { is_expected.to eq divided_data }
      end
    end

    context 'refused' do
      [
        ['', '(A => B ∨ φ(x)', :refused]
      ].each do |left_data, right_data, result|
        let(:left_data) { left_data }
        let(:right_data) { right_data }
        let(:result) { result }
        it { is_expected.to eq divided_data }
      end
    end
  end

  describe '#spilt_divide' do
    subject { FormulaParser.split_divide(data) }
    context 'accepted' do
      [
        ['(A => B)', '∨ φ(x)', :accepted],
        ['A', '=> B ∨ φ(x)', :accepted],
        ['φ(x)', '=> B ∨ φ(x)', :accepted],
        ['=>', 'B ∨ φ(x)', :accepted],
        ['∧', 'B ∨ φ(x)', :accepted]
      ].each do |left_data, right_data, result|
        let(:left_data) { left_data }
        let(:right_data) { right_data }
        let(:result) { result }
        it { is_expected.to eq divided_data }
      end
    end

    context 'refused' do
      [
        ['', '(A => B ∨ φ(x)', :refused]
      ].each do |left_data, right_data, result|
        let(:left_data) { left_data }
        let(:right_data) { right_data }
        let(:result) { result }
        it { is_expected.to eq divided_data }
      end
    end
  end
end
