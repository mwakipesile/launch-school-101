def position_from_1_empty_slot_combo(winning_combos)
  combo = winning_combos.find { |h| h.values.count('O') == 2 }
  combo = winning_combos.find { |h| h.values.count('X') == 2 } unless combo
  combo.key(' ') if combo
end

def corner_position?(position)
  CORNER_POSITIONS.include?(position)
end

def position_from_2_empty_slots_combo(winning_combos)
  winning_combos.each do |combo|
    combo_values = combo.values
    
    if combo_values.count(' ') == 2 && combo_values.include?('X')
      combo.each { |k, v| return k if v == ' ' && corner_position?(k) }
    end
  end
  
  false
end