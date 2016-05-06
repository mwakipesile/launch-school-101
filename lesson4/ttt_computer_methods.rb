def position_from_1_empty_slot_line(winning_lines)
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

def position_from_2_empty_slots_line(board, winning_lines)
  return position_when_player_has_center(winning_lines) if board[CENTER_POSITION] == CROSS
  position_when_computer_has_center(winning_lines)
end

def position_when_player_has_center(winning_lines)
  winning_lines.each do |line|
    line_values = line.values

    if line_values.count(EMPTY_POSITION) == 2 && line_values.include?(CROSS)
      line.each { |k, v| return k if v == EMPTY_POSITION && corner_position?(k) }
    end
  end

  winning_lines[0].key(EMPTY_POSITION) if winning_lines.count == 1
end

def position_when_computer_has_center(winning_lines)
  position = position_from_middle_winning_line(winning_lines)
  position = position_from_diagonal_winning_line(winning_lines) unless position
  return position if position

  winning_lines[0].key(EMPTY_POSITION) if winning_lines.count == 1
end

def position_from_middle_winning_line(winning_lines)
  winning_lines.each do |line|
    line_values = line.values

    if line_values.include?(NOUGHT) && line_values.count(EMPTY_POSITION) == 2
      line.each_key { |k| return k if edge_position?(k) }
    end
  end

  false
end

def position_from_diagonal_winning_line(winning_lines)
  position_frequency =  [:position, 0]

  winning_lines.each do |line|
    line_values = line.values

    next unless line_values.include?(CROSS)
    next unless line_values.count(EMPTY_POSITION) == 2
    line.each_key do |k|
      next unless corner_position?(k)
      frequency = winning_lines.map(&:flatten).flatten.count(k)
      return k if frequency == 3
      position_frequency = [k, frequency] if frequency > position_frequency[1]
    end
  end

  return position_frequency[0] if position_frequency[1] > 0
end
