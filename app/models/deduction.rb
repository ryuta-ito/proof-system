# deduction:
#   <upper_proofs>
#   ------ (<rule_name>)
#   <lower_proof>.
#
# uppper_proofs:
#   <proof_1>, ..., <proof_n>

class Deduction
  attr_accessor :upper_proofs, :lower_proof, :rule

  class << self
    def multi_build_by_file(file_path)
      parse_deductions(FileConnector.read file_path).map do |deduction_data|
        build(deduction_data)
      end
    end

    def build(deduction_data)
      new.tap do |deduction|
        deduction.upper_proofs = Proof.multi_build(parse_deduction_upper deduction_data)
        deduction.lower_proof = Proof.build(parse_deduction_lower deduction_data)
        deduction.rule = Rules.build(parse_rule_name deduction_data)
      end
    end

    private

    def parse_deductions(deductions_data)
      deductions_data.split('.')
    end

    def parse_deduction_upper(deduction_data)
      deduction_data.split(/------.+\)/)[0].strip
    end

    def parse_deduction_lower(deduction_data)
      deduction_data.split(/------.+\)/)[1].strip
    end

    def parse_rule_name(deduction_data)
      deduction_data.match(/------.+\((?<rule_name>.+)\)/)[:rule_name]
    end
  end

  def show
    upper_proofs_str = upper_proofs.map do |proof|
      proof.str
    end.join("\n")
    puts "#{upper_proofs_str}\n------ (#{rule.name})\n#{lower_proof.str}"
  end

  def satisfy?
    rule.module.satisfy? self
  end

  def obvious?
    upper_proofs.all? { |upper_proof| upper_proof.obvious? }
  end

  def all_proofs
    upper_proofs + [lower_proof]
  end
end
