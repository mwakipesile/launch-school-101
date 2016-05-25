# frozen_string_literal: true
require './move.rb'
require './player.rb'

# Main game class
class RockPaperScissors
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def run
    display_welcome

    loop do
      human.choose
      computer.choose
      display_results
      break unless play_again?
    end

    display_goodbye
  end

  private

  def display_welcome
    puts "Welcome to Rock, Paper, Scissors challenge #{human.name}!"
  end

  def display_goodbye
    puts "Thanks for playing Rock, Paper, Scissors. Bye!"
  end

  def display_results
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
    puts results
  end

  def results
    return "#{human.name} won!" if human.move.beats?(computer.move)
    return "#{computer.name} won!" if computer.move.beats?(human.move)
    'It\'s a tie'
  end

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

RockPaperScissors.new.run
