def play_again?(message = 'new')
  prompt(message)
  answer = gets.chomp
  clear_screen
  return true if answer.downcase.start_with?('y')
  return false if answer.downcase.start_with?('n')
  play_again?('invalid_choice')
end