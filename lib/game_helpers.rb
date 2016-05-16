def play_again?(message = 'new')
  loop do
    prompt(message)
    answer = gets.chomp
    return false if answer.downcase.start_with?('n')

    if answer.downcase.start_with?('y')
      clear_screen
      return true
    end

    message = 'invalid_choice'
  end
end
