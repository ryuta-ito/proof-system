# deduction:
#   <upper_sequents>
#   ------ (<rule_name>)
#   <lower_sequent>.
#
# uppper_sequents:
#   <sequent_1>, ..., <sequent_n>

class Deduction
  attr_accessor :upper_sequents, :lower_sequent, :rule

  include ActiveModel::Model

  class << self
    def multi_build_by_file(file_path)
      parse_deductions(FileConnector.read file_path).map do |deduction_data|
        build(deduction_data)
      end
    end

    def build(deduction_data)
      new( upper_sequents: Sequent.multi_build(parse_deduction_upper deduction_data),
           lower_sequent: Sequent.build(parse_deduction_lower deduction_data),
           rule: Rules.build(parse_rule_name deduction_data) )
    end

    private

    def parse_deductions(deductions_data)
      deductions_data.split(/\.$/)
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
    upper_sequents_str = upper_sequents.map do |sequent|
      sequent.str
    end.join("\n")
    puts "#{upper_sequents_str}\n------ (#{rule.name})\n#{lower_sequent.str}."
  end

  def satisfy?
    rule.module.satisfy? self
  end

  def obvious?
    upper_sequents.all? { |upper_sequent| upper_sequent.obvious? }
  end

  def all_sequents
    upper_sequents + [lower_sequent]
  end
end
