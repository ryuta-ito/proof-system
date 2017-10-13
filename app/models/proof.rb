# proof:
#   <axiom> |- <theorem>

class Proof
  attr_accessor :axiom, :theorem

  include ActiveModel::Model

  class << self
    def multi_build(upper_proofs_data)
      parse_upper_proofs_data(upper_proofs_data).map do |proof_data|
        build(proof_data)
      end
    end

    def build(proof_data)
      new( axiom: Axiom.build(parse_left proof_data),
           theorem: Formula.build(parse_right proof_data) )
    end

    private

    def parse_left(proof_data)
      proof_data.split('|-')[0].strip
    end

    def parse_right(proof_data)
      proof_data.split('|-')[1].strip
    end

    def parse_upper_proofs_data(upper_proofs_data)
      upper_proofs_data.split("\n")
    end
  end

  def show
    puts str
  end

  def str
    "#{axiom.str} |- #{ParenthesesParser.strip_edge_parentheses(theorem.str)}"
  end

  def obvious?
    axiom.formulas.any? do |formula|
      theorem.class === formula && theorem.identify?(formula)
    end
  end

  def create_proof_figure
    ProofFigure.create_proof_figure(self)
  end

  def possible_premises
  end
end
