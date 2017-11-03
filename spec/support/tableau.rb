shared_context 'tableau lets' do
  let(:contraposition_tableau) do
    <<~EOS
      A => B
      > (¬B => ¬A)
      ¬B
      > ¬A
      > B
      A
        B
      > A
    EOS
  end

  let(:predicate_tableau_1) do
    <<~EOS
      ∀x.P(x) ∨ Q
      > ∀y.(P(y) ∨ Q)
        Q
        > (P(B) ∨ Q)
        > P(B)
        > Q
      ∀x.P(x)
      > (P(A) ∨ Q)
      > P(A)
      > Q
      P(A)
    EOS
  end
end
