# atom:
#   P | <predicate_name>(<term_1> ... <term_n>)

class Atom < Formula
  attr_accessor :str, :predicate_name, :arguments

  class << self
    def build(atom_data)
      case atom_data
      when /^∃/
        Existence.build(atom_data)
      when /^∀/
        Universal.build(atom_data)
      else
        build_atom(atom_data)
      end
    end

    private

    def build_atom(atom_data)
      new.tap do |atom|
        atom.str = atom_data
        atom.predicate_name = parse_predicate_name(atom_data)
        atom.arguments = parse_arguments(atom_data).map do |term_data|
          Term.build(term_data)
        end
      end
    end

    def parse_predicate_name(atom_data)
      predicate?(atom_data) ? atom_data.split('(').first.strip : ''
    end

    def parse_arguments(atom_data)
      if predicate?(atom_data)
        TermParser.split strip_predicate(atom_data)
      else
        []
      end
    end

    def strip_predicate(predicate_data)
      predicate_data.sub(/^\w+\(/, '').sub(/\)$/, '')
    end

    def predicate?(atom_data)
      atom_data.include?('(')
    end
  end

  def identify?(atom)
    return false unless self.class === atom

    if predicate_name.empty?
      atom.str == str
    else
      atom.predicate_name == predicate_name &&
        (atom.arguments.zip arguments).all? do |given_term, self_term|
          given_term.identify? self_term
        end
    end
  end
end
