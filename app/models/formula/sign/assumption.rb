module Sign
  module Assumption
    def alpha_signs
      [Conjunction, Negation]
    end

    def beta_signs
      [Disjunction, Imply]
    end

    def gamma_sign
      Universal
    end

    def delta_sign
      Existence
    end
  end
end
