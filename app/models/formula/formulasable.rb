module Formulasable
  def all_atom?
    formulas.all? { |formula| Atom === formula }
  end

  def substitute(target, replace)
    if Array === replace
      self.class.new( formulas: formulas.flat_map { |formula| formula.identify?(target) ? replace : formula } )
    else
      self.class.new( formulas: formulas.map { |formula| formula.identify?(target) ? replace : formula } )
    end
  end

  def add_formula(formula)
    self.class.new( formulas: formulas + [formula] )
  end

  def delete_formula(target_formula)
    self.class.new( formulas: formulas.select { |formula| !target_formula.identify?(formula) } )
  end

  def deductive_sequents(sequent)
    formula = formulas.find { |formula| !(Atom === formula) }
    formula ? formula.deductive_sequents(sequent, self) : []
  end

  def identify?(formulas_object)
    formulas.all? do |formula_a|
      formulas_object.formulas.any? do |formula_b|
        formula_a.identify? formula_b
      end
    end
  end
end
