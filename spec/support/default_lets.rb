shared_context 'default lets' do
  %w[x y z].each do |var|
    let("variable_#{var}".to_sym) { Variable.build(var) }
  end

  %w[A B C].each do |c|
    let("constant_#{c}".to_sym) { Constant.build(c) }
  end

  %w[f].each do |fun|
    %w[A B x y].each do |arg_1|
      let("function_#{fun}_#{arg_1}") { Function.build("#{fun}(#{arg_1})") }

      %w[A B x y].each do |arg_2|
        let("function_#{fun}_#{arg_1}_#{arg_2}") { Function.build("#{fun}(#{arg_1} #{arg_2})") }
      end
    end
  end

  %w[x y].each do |var|
    %w[A B].each do |c|
      let("substitution_#{c}_#{var}".to_sym) { Substitutions::Substitution.new(Constant.build(c), Variable.build(var)) }
    end
  end
end
