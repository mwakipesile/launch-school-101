# frozen_string_literal: true
# Rock Paper Scissors base class
class RockPaperScissors
  include Game
  attr_accessor :human, :computer

  WINNING_SCORE = 4

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
      display_current_score

      if winner?
        display_winner
        break
      elsif !play_again?
        break
      end
    end

    display_goodbye
  end

  private

  def prompt(message)
    puts("=> #{message}")
  end

  def display_welcome
    prompt("Welcome to Rock, Paper, Scissors challenge #{human.name}!")
  end

  def display_goodbye
    prompt('Thanks for playing Rock, Paper, Scissors. Bye!')
  end

  def results
    if human.move.beats?(computer.move)
      human.score.add
      return "#{human.name} won!"
    elsif computer.move.beats?(human.move)
      computer.score.add
      return "#{computer.name} won!"
    end
    'It\'s a tie'
  end

  def display_results
    prompt("#{human.name} chose #{human.move}")
    prompt("#{computer.name} chose #{computer.move}")
    prompt(results)
  end

  def display_current_score
    prompt("#{computer.name}'s score: #{computer.score.count}")
    prompt("#{human.name}'s score: #{human.score.count}")
  end

  def winner?
    [human.score.count, computer.score.count].max == WINNING_SCORE
  end

  def overall_winner
    if human.score.count == WINNING_SCORE
      return human.name
    end

    computer.name
  end

  def display_winner
    winner = overall_winner

    prompt("#{winner} is the overall winner!")
  end
end
