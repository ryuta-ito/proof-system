describe Deduction do
  include_context 'default lets'
  let(:deduction) { Deduction.build(deduction_data) }

  describe 'satisfy?' do
    subject { Deduction.build(deduction_data).satisfy? }

    context 'elimination' do
      context 'conjunction' do
        let(:deduction_data) { eli_conj_nk_figure }
        it { is_expected.to be true }
      end

      context 'disjunction' do
        let(:deduction_data) { eli_disj_nk_figure }
        it { is_expected.to be true }
      end
    end

    context 'introduce' do
      context 'conjunction' do
        let(:deduction_data) { intro_conj_nk_figure }
        it { is_expected.to be true }
      end

      context 'disjunction' do
        let(:deduction_data) { intro_disj_nk_figure }
        it { is_expected.to be true }
      end
    end
  end

  describe '#show' do
    subject { deduction.show }
    let(:deduction_data) { contraposition_nk_figure }
    it { expect { subject }.to output(contraposition_nk_figure).to_stdout }
  end
end
