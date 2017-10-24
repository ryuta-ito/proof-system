describe Universal do
  describe '#deductive_sequents_axiom' do
    subject { universal.deductive_sequents_axiom(sequent).first }
    let(:universal) { Universal.build('∀x.P(x y)') }

    context 'no constants' do
      let(:sequent) { Sequent.build('∀x.P(x y) |- ∀x.P(x y)') }
      it { is_expected.to identify(Sequent.build('∀x.P(x y), P(A y) |- ∀x.P(x y)')) }
    end

    context 'exist constants' do
      let(:sequent) { Sequent.build('∀x.P(x y) |- P(A B)') }
      it { is_expected.to identify(Sequent.build('∀x.P(x y), P(A y), P(B y) |- P(A B)')) }
    end
  end

  describe '#deductive_sequents_consequece' do
    subject { universal.deductive_sequents_consequece(sequent).first }
    let(:universal) { Universal.build('∀x.P(x y)') }

    context 'no constants' do
      let(:sequent) { Sequent.build('∀x.P(x y) |- ∀x.P(x y)') }
      it { is_expected.to identify(Sequent.build('∀x.P(x y) |- P(A y)')) }
    end

    context 'exist constants' do
      let(:sequent) { Sequent.build('∀x.P(x y) |- ∀x.P(x B)') }
      let(:universal) { Universal.build('∀x.P(x B)') }
      it { is_expected.to identify(Sequent.build('∀x.P(x y) |- P(C B)')) }
    end
  end
end
