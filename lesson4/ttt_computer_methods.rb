def position_at_immediate_risk(winning_lines)
  line = winning_lines.find { |h| h.values.count(NOUGHT) == 2 }
  line = winning_lines.find { |h| h.values.count(CROSS) == 2 } unless line
  line.key(EMPTY_POSITION) if line
end

def corner_position?(position)
  CORNER_POSITIONS.include?(position)
end

def edge_position?(position)
  EDGE_POSITIONS.include?(position)
end

def at_risk_position_from_2_empty_slots_line(board, winning_lines)
  if board[CENTER_POSITION] == CROSS
    return at_risk_position_when_player_has_center(winning_lines)
  end
  at_risk_position_when_computer_has_center(winning_lines)
end

def at_risk_position_when_player_has_center(winning_lines)
  winning_lines.each do |line|
    line_values = line.values

    if line_values.count(EMPTY_POSITION) == 2 && line_values.include?(CROSS)
      line.each { |k, v| return k if v == EMPTY_POSITION && corner_position?(k) }
    end
  end

  winning_lines[0].key(EMPTY_POSITION) if winning_lines.count == 1
end

def at_risk_position_when_computer_has_center(winning_lines)
  position = at_risk_position_from_middle_line(winning_lines)
  position = at_risk_position_from_diagonal_line(winning_lines) unless position
  return position if position

  winning_lines[0].key(EMPTY_POSITION) if winning_lines.count == 1
end

def at_risk_position_from_middle_line(winning_lines)
  winning_lines.each do |line|
    line_values = line.values

    if line_values.include?(NOUGHT) && line_values.count(EMPTY_POSITION) == 2
      line.each_key { |k| return k if edge_position?(k) }
    end
  end

  false
end

def at_risk_position_from_diagonal_line(winning_lines)
  position_frequency =  [nil, 0]

  winning_lines.each do |line|
    line_values = line.values

    next unless line_values.include?(CROSS)
    next unless line_values.count(EMPTY_POSITION) == 2

    position, frequency = corner_position_and_occurence_in(winning_lines, line)
    return position if frequency == 3
    next if position.nil?
    position_frequency = [position, frequency] if position_frequency[1] < frequency
  end

  position_frequency[0]
end

def corner_position_and_occurence_in(winning_lines, line)
  position_frequency = [nil, 0]

  line.each_key do |position|
    next unless corner_position?(position)
    frequency = winning_lines.map(&:flatten).flatten.count(position)
    return [position, frequency] if frequency == 3
    position_frequency = [position, frequency] if frequency > position_frequency[1]
  end

  position_frequency
end
