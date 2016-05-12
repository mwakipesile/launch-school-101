def position_at_immediate_risk(board)
  lines = lines_with_path_to_win(board)

  line = lines.find { |winning_line| winning_line.values.count(NOUGHT) == 2 }
  line = lines.find { |risk_line| risk_line.values.count(CROSS) == 2 } unless line
  line.key(EMPTY_SQUARE) if line
end

def corner_position?(position)
  CORNER_POSITIONS.include?(position)
end

def edge_position?(position)
  EDGE_POSITIONS.include?(position)
end

def at_risk_position_from_2_empty_slots_line(board)
  winning_lines = lines_with_path_to_win(board)

  if board[CENTER_POSITION] == CROSS
    return at_risk_position_when_player_has_center(winning_lines)
  end
  at_risk_position_when_computer_has_center(winning_lines)
end

def at_risk_position_when_player_has_center(winning_lines)
  winning_lines.each do |line|
    line_squares = line.values

    next unless line_squares.count(EMPTY_SQUARE) == 2 && line.value?(CROSS)

    line.each do |position, square|
      return position if square == EMPTY_SQUARE && corner_position?(position)
    end
  end
end

def at_risk_position_when_computer_has_center(winning_lines)
  position = at_risk_position_from_middle_line(winning_lines)
  position = at_risk_position_from_diagonal_line(winning_lines) unless position
  position if position
end

def at_risk_position_from_middle_line(winning_lines)
  winning_lines.each do |line|
    if line.key?(CENTER_POSITION) && line.values.count(EMPTY_SQUARE) == 2
      line.each_key { |position| return position if edge_position?(position) }
    end
  end

  false
end

def at_risk_position_from_diagonal_line(winning_lines)
  position_frequency =  [nil, 0]

  winning_lines.each do |line|
    next unless line.value?(CROSS)
    next unless line.values.count(EMPTY_SQUARE) == 2

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
