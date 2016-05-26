# Module for reusable game methods
module Game
  def play_again?
    puts 'Would you like to play again? Y/n'

    loop do
      ans = gets.chomp
      return true if ans.downcase.start_with?('y')
      return false if ans.downcase.start_with?('n')
      puts 'Wrong input. Please enter Y or n'
    end
  end
end
