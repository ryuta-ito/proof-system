describe Tableau do
  include_context 'default lets'

  describe '#expantion' do
    subject { tableau.expantion }

    shared_context 'set parent tableau' do |parent_tableau|
      before do
        tableau.parent = parent_tableau
        parent_tableau.children = [tableau]
      end
    end

    context 'assumption' do
      let(:tableau) { Tableau::Assumption.new( formula: formula ) }

      context 'binary' do
        context 'imply' do
          let(:formula) { Imply.new( left: atom_A, right: atom_B) }
          it { expect(subject.children).to identify_array([ Tableau::Consequence.new( formula: atom_A ),
                                                            Tableau::Assumption.new( formula: atom_B ) ]) }
        end

        context 'conjunction' do
          let(:formula) { Conjunction.new( left: atom_A, right: atom_B) }
          it { expect(subject.children).to identify_array([ Tableau::Assumption.new( formula: atom_A ) ]) }
          it { expect(subject.children.first.children).to identify_array([ Tableau::Assumption.new( formula: atom_B ) ]) }
        end

        context 'disjunction' do
          let(:formula) { Disjunction.new( left: atom_A, right: atom_B) }
          it { expect(subject.children).to identify_array([ Tableau::Assumption.new( formula: atom_A ),
                                                            Tableau::Assumption.new( formula: atom_B ) ]) }
        end
      end

      context 'negation' do
        let(:formula) { Negation.new( formula: atom_A) }
        it { expect(subject.children).to identify_array([ Tableau::Consequence.new( formula: atom_A ) ]) }
      end

      context 'quantifier' do
        context 'existence' do
          context 'no constants' do
            let(:formula) { existence_x_P_x }
            it { expect(subject.children).to identify_array([ Tableau::Assumption.new( formula: predicate_P_A ) ]) }
          end

          context 'constants exist' do
            let(:formula) { existence_x_P_x }
            include_context 'set parent tableau', Tableau::Assumption.new( formula: Formula.build('P(A)') )

            it do
              expect(subject.children).to identify_array([ Tableau::Assumption.new( formula: predicate_P_B ) ])
            end
          end
        end

        context 'universal' do
          context 'no constants' do
            let(:formula) { universal_x_P_x }
            it { expect(subject.children).to identify_array([ Tableau::Assumption.new( formula: predicate_P_A ) ]) }
          end

          context 'constants exist' do
            let(:formula) { universal_x_P_x }
            include_context 'set parent tableau', Tableau::Assumption.new( formula: Formula.build('P(A)') )

            it do
              expect(subject.children).to identify_array([ Tableau::Assumption.new( formula: predicate_P_A ) ])
            end
          end
        end
      end
    end

    context 'consequence' do
      let(:tableau) { Tableau::Consequence.new( formula: formula ) }

      context 'binary' do
        context 'imply' do
          let(:formula) { Imply.new( left: atom_A, right: atom_B) }
          it { expect(subject.children).to identify_array([ Tableau::Assumption.new( formula: atom_A ) ]) }
          it { expect(subject.children.first.children).to identify_array([ Tableau::Consequence.new( formula: atom_B ) ]) }
        end

        context 'conjunction' do
          let(:formula) { Conjunction.new( left: atom_A, right: atom_B) }
          it { expect(subject.children).to identify_array([ Tableau::Consequence.new( formula: atom_A ),
                                                            Tableau::Consequence.new( formula: atom_B ) ]) }
        end

        context 'disjunction' do
          let(:formula) { Disjunction.new( left: atom_A, right: atom_B) }
          it { expect(subject.children).to identify_array([ Tableau::Consequence.new( formula: atom_A ) ]) }
          it { expect(subject.children.first.children).to identify_array([ Tableau::Consequence.new( formula: atom_B ) ]) }
        end
      end

      context 'negation' do
        let(:formula) { Negation.new( formula: atom_A) }
        it { expect(subject.children).to identify_array([ Tableau::Assumption.new( formula: atom_A ) ]) }
      end

      context 'quantifier' do
        context 'existence' do
          context 'no constants' do
            let(:formula) { existence_x_P_x }
            it { expect(subject.children).to identify_array([ Tableau::Consequence.new( formula: predicate_P_A ) ]) }
          end

          context 'constants exist' do
            let(:formula) { existence_x_P_x }
            include_context 'set parent tableau', Tableau::Consequence.new( formula: Formula.build('P(A)') )

            it do
              expect(subject.children).to identify_array([ Tableau::Consequence.new( formula: predicate_P_A ) ])
            end
          end
        end

        context 'universal' do
          context 'no constants' do
            let(:formula) { universal_x_P_x }
            it { expect(subject.children).to identify_array([ Tableau::Consequence.new( formula: predicate_P_A ) ]) }
          end

          context 'constants exist' do
            let(:formula) { universal_x_P_x }
            include_context 'set parent tableau', Tableau::Assumption.new( formula: Formula.build('P(A)') )

            it do
              expect(subject.children).to identify_array([ Tableau::Assumption.new( formula: predicate_P_B ) ])
            end
          end
        end
      end
    end
  end

  describe '#show' do
    subject { tableau.show }

    context 'contraposition' do
      let(:tableau) { Tableau.expantion_build_by_sequent(Sequent.build('A => B |- ¬B => ¬A')) }
      let(:tableau_figure) do
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
      it { expect { subject }.to output(tableau_figure).to_stdout }
    end

    context 'predicate example' do
      let(:tableau) { Tableau.expantion_build_by_sequent(Sequent.build('∀x.P(x) ∨ Q |- ∀y.(P(y) ∨ Q)')) }
      let(:tableau_figure) do
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
      it { expect { subject }.to output(tableau_figure).to_stdout }
    end
  end
end
