# deduction:
#   <deduction_1>
#     ...
#       <deduction_n>
#   ------ (<rule_name>)
#   <lower_sequent>
#
#   |  <lower_sequent>
#

class Deduction
  attr_accessor :upper_deductions, :upper_sequents, :lower_sequent, :rule

  include ActiveModel::Model

  class << self
    def multi_build_by_file(file_path)
      build FileConnector.read(file_path)
    end

    def build(deduction_data)
      new( upper_deductions: (parse_upper_deductions deduction_data).map { |deduction_data| build(deduction_data) },
           lower_sequent: Sequent.build(parse_lower_sequent deduction_data),
           rule: Rules.new( name: parse_rule_name(deduction_data) ) )
    end

    private

    def parse_upper_deductions(deduction_data)
      IndentParser.group_reverse(strip_lower_sequent(deduction_data))
    end

    def strip_lower_sequent(deduction_data)
      deduction_data.split("\n").reverse.drop(2).reverse
    end

    def parse_lower_sequent(deduction_data)
      deduction_data.split(/------.+\)/).last.strip
    end

    def parse_rule_name(deduction_data)
      if deduction_data.match(/------/)
        deduction_data.strip.split("\n").reverse[1].match(/------.+\((?<rule_name>.+)\)/)[:rule_name]
      else
        ''
      end
    end
  end

  def show
    puts reverse_str.split("\n").reverse.join("\n")
  end

  def reverse_str(tab_base='')
    if rule.empty?
      "#{tab_base}#{lower_sequent.str.lstrip}\n"
    else
      "#{tab_base}#{lower_sequent.str.lstrip}\n" +
        "#{tab_base}------ (#{rule.name})\n" +
        upper_deductions.map.with_index do |deduction, index|
          [deduction, '  ' * (upper_deductions.size - index - 1)]
        end.flat_map do |deduction, tab|
          deduction.reverse_str(tab_base + tab)
        end.join
    end
  end

  def leaf?
    upper_deductions.empty?
  end

  def satisfy?
    return lower_sequent.obvious? if leaf?
    rule.module.satisfy?(self) && upper_deductions.all?(&:satisfy?)
  end

  def upper_sequents
    upper_deductions.map { |deduction| deduction.lower_sequent }
  end
end
