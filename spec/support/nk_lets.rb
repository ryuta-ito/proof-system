shared_context 'nk lets' do
  let(:eli_conj_nk_figure) do
    <<~EOS
      A∧B |- A∧B
      ------ (∧ E)
      A∧B |- B
    EOS
  end

  let(:eli_disj_nk_figure) do
    <<~EOS
      P ∨ Q, R |- P ∨ Q
        P ∨ Q, R, P |- R
          P ∨ Q, R, Q |- R
      ------ (∨ E)
      P ∨ Q, R |- R
    EOS
  end

  let(:intro_conj_nk_figure) do
    <<~EOS
      A,B |- A
        A,B |- B
      ------ (∧ I)
      A,B |- A∧B
    EOS
  end

  let(:intro_disj_nk_figure) do
    <<~EOS
      P |- P
      ------ (∨ I)
      P |- P ∨ Q
    EOS
  end

  let(:contraposition_nk_figure) do
    <<~EOS
      A => ¬B, A, B |- B
        A => ¬B, A, B |- A => ¬B
        A => ¬B, A, B |- A
        ------ (=> E)
        A => ¬B, A, B |- ¬B
      ------ (¬ E)
      A => ¬B, A, B |- ⊥
      ------ (¬ I)
      A => ¬B, B |- ¬A
      ------ (=> I)
      A => ¬B |- B => ¬A
    EOS
  end
end
