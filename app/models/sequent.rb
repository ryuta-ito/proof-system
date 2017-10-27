# sequent:
#   <assumption> |- <theorem>

class Sequent
  attr_accessor :assumption, :theorem, :consequece

  include ActiveModel::Model

  class << self
    def multi_build(upper_sequents_data)
      parse_upper_sequents_data(upper_sequents_data).map do |sequent_data|
        build(sequent_data)
      end
    end

    def build(sequent_data)
      consequece = Sequent::Consequence.build(parse_right sequent_data)
      new( assumption: Sequent::Assumption.build(parse_left sequent_data),
           theorem: consequece.one_formula,
           consequece: consequece )
    end

    private

    def parse_left(sequent_data)
      sequent_data.split('|-')[0].strip
    end

    def parse_right(sequent_data)
      sequent_data.split('|-')[1].strip
    end

    def parse_upper_sequents_data(upper_sequents_data)
      upper_sequents_data.split("\n")
    end
  end

  def show
    puts str
  end

  def str
    "#{assumption.str} |- #{consequece.str}"
  end

  def deductive_str_reverse(count = 0)
    sequents, rule_name = [deductive_sequents.sequents, deductive_sequents.rule_name]
    tab = ' ' * count
    upper_str = "#{tab}#{str}\n#{tab}------ (#{rule_name})\n"

    case sequents.size
    when 2
      upper_str +
        sequents[1].deductive_str_reverse(count + 4) +
        sequents[0].deductive_str_reverse(count)
    when 1
      upper_str + sequents[0].deductive_str_reverse(count)
    else
      "#{tab}#{str}\n"
    end
  end

  def show_lk_proof_figure
    puts lk_proof_figure
  end

  def lk_proof_figure
    deductive_str_reverse.split("\n").reverse.join("\n")
  end

  def obvious?
    assumption.formulas.any? do |formula_a|
      consequece.formulas.any? do |formula_b|
        formula_a.identify?(formula_b)
      end
    end
  end

  def single_obvious?
    [assumption.formulas.size, consequece.formulas.size] == [1, 1] &&
      assumption.formulas.first.identify?(consequece.formulas.first)
  end

  def identify?(sequent)
    assumption.identify?(sequent.assumption) && consequece.identify?(sequent.consequece)
  end

  def both_sides
    [ assumption, consequece ]
  end

  def deductive_sequents
    return weakening if obvious?
    return deductive_sequents_alpha if both_sides.any? { |side| side.has_alpha? }
    return deductive_sequents_beta if both_sides.any? { |side| side.has_beta? }
    return deductive_sequents_delta if both_sides.any? { |side| side.has_delta? }
    deductive_sequents_gamma
  end

  def deductive_sequents_alpha
    return assumption.deductive_sequents_alpha(self) if assumption.has_alpha?
    consequece.deductive_sequents_alpha(self)
  end

  def deductive_sequents_beta
    return assumption.deductive_sequents_beta(self) if assumption.has_beta?
    consequece.deductive_sequents_beta(self)
  end

  def deductive_sequents_delta
    return assumption.deductive_sequents_delta(self) if assumption.has_delta?
    consequece.deductive_sequents_delta(self)
  end

  def deductive_sequents_gamma
    compose( assumption.deductive_sequents_gamma(self),
             consequece.deductive_sequents_gamma(self) )
  end

  def compose(sequents_a, sequents_b)
    rule_name = [sequents_a.rule_name, sequents_b.rule_name].reject(&:empty?).join(', ')
    sequents = [self.class.new( assumption: sequents_a.assumption.add_formulas(sequents_b.assumption),
                                consequece: sequents_a.consequece.add_formulas(sequents_b.consequece) )]
    Sequents.new sequents: sequents, rule_name: rule_name
  end

  def weakening
    return Sequents.build_empty if !obvious? || single_obvious?
    id_formula = assumption.find { |formula_a| consequece.find { |formula_b| formula_a.identify?(formula_b) } }

    if assumption.formulas.size > 1
      weakening_formula = assumption.find { |formula| !id_formula.identify?(formula) }
      w_l_sequent = Sequent.new( assumption: assumption.substitute(weakening_formula, []), consequece: consequece )
      Sequents.new( sequents: [w_l_sequent], rule_name: 'W L' )
    elsif consequece.formulas.size > 1
      weakening_formula = consequece.find { |formula| !id_formula.identify?(formula) }
      w_r_sequent = Sequent.new( assumption: assumption, consequece: consequece.substitute(weakening_formula, []) )
      Sequents.new( sequents: [w_r_sequent], rule_name: 'W R' )
    else
      Sequents.build_empty
    end
  end

  def constants
    both_sides.flat_map &:constants
  end

  def least_constants
    constants.empty? ? [non_used_constant] : constants
  end

  def non_used_constant
    Term.build(constants.empty? ? 'A' : constants.map(&:str).sort.last.next)
  end
end
