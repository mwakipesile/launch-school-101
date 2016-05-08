def valid_position?(available_positions, position)
  position = integer?(position)
  return false unless position
  true if available_positions.include?(position - 1)
end

def update_available_positions(available_positions, used_position)
  available_positions.delete(used_position)
end

def joinor(available_positions, delimiter = ', ', conjunction = 'or')
  positions = available_positions.map { |i| i + 1 }

  positions[-1] = "#{conjunction} #{positions[-1]}" if positions.length > 1
  positions.join(delimiter)
end
