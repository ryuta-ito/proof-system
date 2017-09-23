module OperationParser
  extend ParserBase

  class << self
    def divide(operation_data)
      op_match = (operation_data.strip.match Formula.operation_reg_exp)
      if op_match
        [op_match[:operation], operation_data.sub(/^#{op_match[:operation]}/, '').strip, :accepted]
      else
        [operation_data, :refused]
      end
    end
  end
end
