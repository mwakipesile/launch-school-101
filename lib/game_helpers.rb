def play_again?(message = 'new')
  prompt(message)

  answer = gets.chomp
  return false if answer.downcase.start_with?('n')

  if answer.downcase.start_with?('y')
    clear_screen
    return true
  end

  play_again?('invalid_choice')
end
