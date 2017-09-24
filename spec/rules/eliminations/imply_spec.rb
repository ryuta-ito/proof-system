describe Rules::Eliminations::Imply do
  describe '.satisfy?' do
    let(:deduction) { Deduction.build(deduction_data) }
    subject { Rules::Eliminations::Imply.satisfy?(deduction) }

    context 'valid' do
      let(:deduction_data) do
        """
          {A => B, A} |- A => B
          {A => B, A} |- A
          ------ (=> E)
          {A => B, A} |- B
        """
      end
      it { is_expected.to be true}
    end

    context 'invalid' do
      let(:deduction_data) do
        """
          {A => B, A} |- A => B
          {A => B, A} |- A
          ------ (=> E)
          {A => B, A} |- A
        """
      end
      it { is_expected.to be false}
    end
  end
end
