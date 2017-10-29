describe Tableau do
  include_context 'default lets'

  describe '#expantion' do
    subject { tableau.expantion }

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
            B
            ¬B
            > ¬A
            > B
            A
          > A
          ¬B
          > ¬A
          > B
          A
        EOS
      end
      it { expect { subject }.to output(tableau_figure).to_stdout }
    end
  end
end
