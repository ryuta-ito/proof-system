module Sign
  module Consequence
    def alpha_signs
      [Disjunction, Negation, Imply]
    end

    def beta_signs
      [Sequent::Consequence]
    end

    def gamma_sign
      Existence
    end

    def delta_sign
      Universal
    end
  end
end
