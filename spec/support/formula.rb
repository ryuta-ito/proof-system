shared_context 'formula lets' do
  %w[x y].each do |var|
    %w[A B].each do |c|
      let("substitution_#{c}_#{var}".to_sym) { Substitutions::Substitution.new(Constant.build(c), Variable.build(var)) }
    end
  end

  %w[A B P Q].each do |name|
    let("atom_#{name}".to_sym) { Formula.build(name) }

    %w[x A B].each do |var|
      let("predicate_#{name}_#{var}".to_sym) { Formula.build("#{name}(#{var})") }
    end
  end

  %w[x].each do |var|
    %w[P].each do |predicate|
      let("existence_#{var}_#{predicate}_#{var}".to_sym) { Formula.build("∃#{var}.#{predicate}(#{var})") }
      let("universal_#{var}_#{predicate}_#{var}".to_sym) { Formula.build("∀#{var}.#{predicate}(#{var})") }
    end
  end
end
