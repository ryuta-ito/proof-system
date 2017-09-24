shared_context 'default lets' do
  %w[x y z].each do |var|
    let("variable_#{var}".to_sym) { Variable.build(var) }
  end

  %w[A B C].each do |c|
    let("constant_#{c}".to_sym) { Constant.build(c) }
  end
end
