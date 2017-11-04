class Rules
  module LK
    class << self
      def build(formula, sign)
        Rules.new name: "#{formula.code} #{sign.side}"
      end

      def build_by_sequents(sequents_a, sequents_b)
        Rules.new name: [sequents_a.rule.name, sequents_b.rule.name].reject(&:empty?).join(', ')
      end
    end
  end
end
