# deduction:
#   <deduction_1>
#     ...
#       <deduction_n>
#   ------ (<rule_name>)
#   <lower_sequent>
#
#   |  <lower_sequents>
#

class Deduction
  attr_accessor :upper_deductions, :lower_sequents, :lower_sequent, :rule

  include ActiveModel::Model

  class << self
    def multi_build_by_file(file_path)
      build FileConnector.read(file_path)
    end

    def build(deduction_data)
      deduction = new( upper_deductions: (parse_upper_deductions deduction_data).map { |deduction_data| build(deduction_data) },
                       lower_sequents: (parse_lower_sequents deduction_data).map { |sequent_data| Sequent.build(sequent_data) },
                       rule: Rules.build_by_reverse_figure(deduction_data) )
      deduction.lower_sequent = deduction.lower_sequents.first
      deduction
    end

    private

    def parse_upper_deductions(deduction_data)
      IndentParser.group_reverse(strip_lower_sequents(deduction_data))
    end

    def strip_lower_sequents(deduction_data)
      case deduction_data
      when /------/
        deduction_data.split("\n").reverse.drop(2).reverse
      else
        []
      end
    end

    def parse_lower_sequents(deduction_data)
      case deduction_data
      when /------/
        [deduction_data.split(/------.+\)/).last.strip]
      else
        deduction_data.split("\n")
      end
    end
  end

  def show
    puts reverse_str.split("\n").reverse.join("\n")
  end

  def reverse_str(tab_base='')
    lower_sequents_str = lower_sequents.map do |lower_sequent|
      "#{tab_base}#{lower_sequent.str.lstrip}"
    end.reverse.join("\n") + "\n"
    if rule.empty?
      lower_sequents_str
    else
      lower_sequents_str +
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
    return lower_sequents.all?(&:obvious?) if leaf?
    rule.module.satisfy?(self) && upper_deductions.all?(&:satisfy?)
  end

  def upper_sequents
    upper_deductions.flat_map { |deduction| deduction.lower_sequents }
  end
end
