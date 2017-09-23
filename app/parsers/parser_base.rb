module ParserBase
  def split(data)
    run_split(data, [])
  end

  def divide(data)
    run_divide(start_state, [], data.strip.split(''))
  end

  def conjunction_divide(parser_modules, data)
    run_conjunction_divide([self] + parser_modules, [], data)
  end

  def disjunction_divide(parser_modules, data)
    run_disjunction_divide([self] + parser_modules, data)
  end

  private

  def start_state
    raise NotImplementedError, 'please implement #start_state private class method returns a start state instance'
  end

  def split_divide(data)
    # for overwrite using
    divide(data)
  end

  def run_split(data, splited_data)
    term_data, remain_data, result = split_divide(data)
    return splited_data << remain_data if result == :refused
    return splited_data << term_data if remain_data.empty?
    return splited_data + [term_data, remain_data] if term_data.empty?

    case result
    when :accepted
      run_split(remain_data, splited_data << term_data)
    when :refused
      splited_data + [data, remain_data]
    else
      raise 'HOORAY. you fail parsing...'
    end
  end

  def run_divide(state, accepted_inputs, remain_inputs)
    input = remain_inputs.first
    next_state = state.next_state(input)
    return [accepted_inputs.join.strip, remain_inputs.join.strip, :accepted] if StateBase::Accepted === next_state
    return ['', (accepted_inputs+remain_inputs).join, :refused] if StateBase::Refused === next_state or remain_inputs.empty?

    run_divide(next_state, accepted_inputs+[input], remain_inputs.drop(1))
  end

  def run_conjunction_divide(parser_modules, accepted_data_array, remain_data)
    return [accepted_data_array.join, remain_data, :accepted] if [parser_modules, remain_data].any?(&:empty?)

    accepted_data, remain_data, result = parser_modules.first.divide(remain_data)
    case result
    when :accepted
      run_conjunction_divide(parser_modules.drop(1), accepted_data_array << accepted_data, remain_data)
    when :refused
      ['', accepted_data_array.join + remain_data, :refused]
    else
      raise "#{result} <- invalid divide status"
    end
  end

  def run_disjunction_divide(parser_modules, data)
    parser_modules.each do |parser_module|
      accepted_data, remain_data, result = parser_module.divide(data)
      return [accepted_data, remain_data, result] if result == :accepted
    end

    ['', data, :refused]
  end
end
