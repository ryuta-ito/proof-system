require 'rules/commons'

module Rules::Commons::Axiom
  def axioms_equal?(deduction)
    deduction.all_sequents.map do |sequent|
      sequent.axiom
    end.each_cons(2).to_a.map do |axiom_a, axiom_b|
      axiom_a.identify? axiom_b
    end.all?
  end
end
