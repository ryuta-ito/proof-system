module IndentParser
  class << self
    def group(array_data)
      array_data = array_data.split("\n") unless Array === array_data
      return [] if array_data.empty?
      indent = indent_size(array_data.first)
      take_size = array_data.find_index { |row| indent_size(row) < indent }
      return [array_data.join("\n")] unless take_size
      group( array_data.drop(take_size) ) + [array_data.take(take_size).join("\n")]
    end

    def group_reverse(array_data)
      return [] if array_data.empty?
      indent = indent_size(array_data.last)
      index = array_data.reverse.find_index { |row| indent_size(row) < indent }
      return [array_data.join("\n")] unless index
      drop_size = array_data.size - index
      [array_data.drop(drop_size).join("\n")] + group_reverse( array_data.take(drop_size) )
    end
  end

  private

  def self.indent_size(string)
    string.match(/^\ */).to_s.size
  end
end
