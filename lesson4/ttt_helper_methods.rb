def valid_position?(available_positions, position)
  position = integer?(position)
  return false unless position
  true if available_positions.include?(position - 1)
end

def update_available_positions(available_positions, used_position)
  available_positions.delete(used_position)
end
  