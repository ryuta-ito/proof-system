describe Deduction do
  let(:deduction) { Deduction.build(deduction_data) }

  describe 'satisfy?' do
    subject { Deduction.build(deduction_data).satisfy? }

    context 'elimination' do
      context 'conjunction' do
        let(:deduction_data) do
          '''
            A∧B |- A∧B
            ------ (∧ E)
            A∧B |- B
          '''
        end
        it { is_expected.to be true }
      end

      context 'disjunction' do
        let(:deduction_data) do
          '''
            P ∨ Q, R    |- P ∨ Q
            P ∨ Q, R, P |- R
            P ∨ Q, R, Q |- R
            ------ (∨ E)
            P ∨ Q, R |- R
          '''
        end
        it { is_expected.to be true }
      end
    end

    context 'introduce' do
      context 'conjunction' do
        let(:deduction_data) do
          '''
            A,B |- A
            A,B |- B
            ------ (∧ I)
            A,B |- A∧B
          '''
        end
        it { is_expected.to be true }
      end

      context 'disjunction' do
        let(:deduction_data) do
          '''
            P |- P
            ------ (∨ I)
            P |- P ∨ Q
          '''
        end
        it { is_expected.to be true }
      end
    end
  end
end
