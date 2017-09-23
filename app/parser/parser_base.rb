module ParserBase
  def split(data)
    run_split(data, [])
  end

  def divide(data)
    run_divide(start_state, [], data.strip.split(''))
  end

  private

  def start_state
    raise NotImplementedError, 'please implement #start_state private class method returns a start state instance'
  end

  def run_split(data, splited_data)
    term_data, remain_data, result = split_divide(data)
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
    return [accepted_inputs.join.strip, remain_inputs.join.strip, :refused]  if StateBase::Refused === next_state or remain_inputs.empty?

    run_divide(next_state, accepted_inputs+[input], remain_inputs.drop(1))
  end
end
