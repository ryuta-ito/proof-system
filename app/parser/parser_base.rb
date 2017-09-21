module ParserBase
  def split(terms_data)
    run_split(terms_data, [])
  end

  def divide(terms_data)
    run_divide(start_state, [], terms_data.split(''))
  end

  private

  def start_state
    raise NotImplementedError, 'please implement #start_state_class private class method returns a start state instance'
  end

  def run_split(terms_data, splited_terms_data)
    term_data, remain_data, result = divide(terms_data)
    return splited_terms_data << term_data if remain_data.empty?
    return splited_terms_data + [term_data, remain_data] if term_data.empty?

    case result
    when :accepted
      run_split(remain_data, splited_terms_data << term_data)
    when :refused
      splited_terms_data + [terms_data, remain_data]
    else
      raise 'HOORAY. you fail parsing term.'
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
