describe Rules::Introduces::Imply do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { Rules::Introduces::Imply.satisfy?(deduction) }

    context 'valid' do
      let(:deduction_data) do
        <<~EOS
          A, B |- B
          ------ (=> I)
          B |- A => B
        EOS
      end
      it { is_expected.to be true }
    end

    context 'invalid' do
      let(:deduction_data) do
        <<~EOS
          A, B |- B
          ------ (=> I)
          B |- A => A
        EOS
      end
      it { is_expected.to be false }
    end
  end
end
