# atom:
#   P | <predicate_name>(<term_1> ... <term_n>)

class Atom < Formula
  attr_accessor :str, :predicate_name, :arguments

  include ActiveModel::Model

  class << self
    def build(atom_data)
      case atom_data
      when %r{^#{Existence.code}}
        Existence.build(atom_data)
      when %r{^#{Universal.code}}
        Universal.build(atom_data)
      when %r{^#{Negation.code}}
        Negation.build(atom_data)
      when %r{^#{Contradiction.str}}
        Contradiction.new
      else
        build_atom(atom_data)
      end
    end

    private

    def build_atom(atom_data)
      new( str: atom_data,
           predicate_name: parse_predicate_name(atom_data),
           arguments: parse_arguments(atom_data).map { |term_data| Term.build(term_data) } )
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

  def predicate?
    !predicate_name.empty?
  end

  def free_variables
    arguments.flat_map &:free_variables
  end

  def constants
    arguments.flat_map &:constants
  end

  def substitute(target, replace)
    if identify?(target)
      replace
    else
      if predicate?
        arguments_data = arguments.map do |term|
          term.substitute(target, replace)
        end.map(&:str).join(' ')
        self.class.build "#{predicate_name}(#{arguments_data})"
      else
        self
      end
    end
  end

  def unify(target_formula)
    condition = (self.class === target_formula) &&
      arguments.size == target_formula.arguments.size &&
      predicate_name == target_formula.predicate_name

    return NonUnifier.build unless condition
    return Unifier.build if identify?(target_formula)

    arguments.zip(target_formula.arguments).reduce(Unifier.build) do |unifier, (term_a, term_b)|
      unifier.compose term_a.unify(term_b)
    end
  end
end
