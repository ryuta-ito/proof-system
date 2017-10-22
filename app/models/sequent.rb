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
    axiom.all_atom? ? [] : axiom.deductive_sequents(self)
  end
end
