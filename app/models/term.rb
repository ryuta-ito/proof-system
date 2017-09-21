# term: #   <constant> | <variable> | <function>

class Term
  class << self
    def build(term_data)
      case term_data
      when %r{^\w+\(}
        Function.build(term_data)
      when %r{^[a-z]}
        Constant.build(term_data)
      when %r{^[A-Z]}
        Variable.build(term_data)
      else
        raise "#{term_data} <- invalid term format"
      end
    end
  end
end
