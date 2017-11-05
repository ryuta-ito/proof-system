shared_context 'sequent lets' do
  let(:contraposition_sequent_figure) do
    <<~EOS
      A |- A
      ------ (W R)
      A |- B, A
          B |- B
          ------ (W L)
          B, A |- B
      ------ (=> L)
      A => B, A |- B
      ------ (¬ R)
      A => B |- ¬A, B
      ------ (¬ L)
      A => B, ¬B |- ¬A
      ------ (=> R)
      A => B |- ¬B => ¬A
    EOS
  end
  let(:universal_quantifier_sequent_figure_1) do
    <<~EOS
      P(A) |- P(A)
      ------ (W R)
      P(A) |- P(A), Q
      ------ (W L)
      ∀x.P(x), P(A) |- P(A), Q
      ------ (∀ L)
      ∀x.P(x) |- P(A), Q
      ------ (∨ R)
      ∀x.P(x) |- P(A) ∨ Q
      ------ (∀ R)
      ∀x.P(x) |- ∀y.(P(y) ∨ Q)
          Q |- Q
          ------ (W R)
          Q |- P(A), Q
          ------ (∨ R)
          Q |- P(A) ∨ Q
          ------ (∀ R)
          Q |- ∀y.(P(y) ∨ Q)
      ------ (∨ L)
      ∀x.P(x) ∨ Q |- ∀y.(P(y) ∨ Q)
    EOS
  end
end
