module Deductible
  def self.included(klass)
    klass.include Formulasable
  end

  def all_atom?
    formulas.all? { |formula| Atom === formula }
  end

  def alpha_formula
    formulas.find { |formula| alpha_signs.any? { |alpha_sign| alpha_sign === formula } }
  end

  def beta_formula
    formulas.find { |formula| beta_signs.any? { |beta_sign| beta_sign === formula } }
  end

  alias :has_alpha? :alpha_formula
  alias :has_beta? :beta_formula

  def proposition_op?(formula)
    (Formula::Binary === formula) || (Negation === formula)
  end

  def has_gamma?
    formulas.any? { |formula| gamma_sign === formula }
  end

  def has_delta?
    formulas.any? { |formula| delta_sign === formula }
  end

  def has_gamma?
    formulas.any? { |formula| gamma_sign === formula }
  end

  def has_delta?
    formulas.any? { |formula| delta_sign === formula }
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

  def deductive_sequents_alpha(sequent)
    has_alpha? ? alpha_formula.deductive_sequents(sequent, self) : []
  end

  def deductive_sequents_beta(sequent)
    has_beta? ? beta_formula.deductive_sequents(sequent, self) : []
  end

  def deductive_sequents_gamma(sequent)
    formula = formulas.find { |formula| gamma_sign === formula }
    formula ? formula.deductive_sequents(sequent, self) : []
  end

  def deductive_sequents_delta(sequent)
    formula = formulas.find { |formula| delta_sign === formula }
    formula ? formula.deductive_sequents(sequent, self) : []
  end
end
