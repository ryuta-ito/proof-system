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
  attr_accessor :upper_deductions, :lower_sequent, :rule

  include ActiveModel::Model

  class << self
    def multi_build_by_file(file_path)
      build FileConnector.read(file_path)
    end

    def build(deduction_data)
      new( upper_deductions: (parse_upper_deductions deduction_data).map { |deduction_data| build(deduction_data) },
           lower_sequent: Sequent.build(parse_lower_sequent deduction_data),
           rule: Rules.build(parse_rule_name deduction_data) )
    end

    private

    def parse_upper_deductions(deduction_data)
      group_by_indent(strip_lower_sequent(deduction_data))
    end

    def strip_lower_sequent(deduction_data)
      deduction_data.split("\n").reverse.drop(2).reverse
    end

    def group_by_indent(deductions_data)
      return [] if deductions_data.empty?
      indent = indent_size(deductions_data.last)
      index = deductions_data.reverse.find_index { |deduction_row| indent_size(deduction_row) < indent }
      return [deductions_data.join("\n")] unless index
      drop_size = deductions_data.size - index
      [deductions_data.drop(drop_size).join("\n")] + group_by_indent( deductions_data.take(drop_size) )
    end

    def indent_size(deduction_row)
      deduction_row.match(/^\ */).to_s.size
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
