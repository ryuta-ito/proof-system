# sequent:
#   <axiom> |- <theorem>

class Sequent
  attr_accessor :axiom, :theorem, :consequece

  include ActiveModel::Model

  class << self
    def multi_build(upper_sequents_data)
      parse_upper_sequents_data(upper_sequents_data).map do |sequent_data|
        build(sequent_data)
      end
    end

    def build(sequent_data)
      new( axiom: Sequent::Axiom.build(parse_left sequent_data),
           theorem: Formula.build(parse_right(sequent_data).split(',').first.strip),
           consequece: Sequent::Consequence.build(parse_right sequent_data))
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
    "#{axiom.str} |- #{consequece.str}"
  end

  def deductive_str_reverse(count = 0)
    sequents, rule_name = deductive_sequents
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
    axiom.formulas.any? do |formula|
      theorem.class === formula && theorem.identify?(formula)
    end
  end

  def identify?(sequent)
    axiom.identify?(sequent.axiom) && consequece.identify?(sequent.consequece)
  end

  def create_sequent_figure
    SequentFigure.create_sequent_figure(self)
  end

  def deductive_sequents
    return consequece.deductive_sequents(self) unless consequece.all_atom?
    axiom.all_atom? ? [[], nil] : axiom.deductive_sequents(self)
  end
end
