# frozen_string_literal: true
require 'yaml'
require '../../modules/helper.rb'
require '../../modules/game.rb'
require '../score.rb'
require './move.rb'
require './player.rb'

# Rock Paper Scissors base class
class RockPaperScissorsBase
  include Helper
  include Game

  LANGUAGE = 'en'
  WINNING_SCORE = 10

  attr_reader :human, :computer, :human_score, :computer_score

  def initialize
    @human = Human.new
    @computer = Computer.new
    @human_score = Score.new
    @computer_score = Score.new
  end

  def run
    display_welcome

    loop do
      human.choose
      computer.choose
      update_score
      display_results
      display_score

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

  def display_welcome
    prompt('welcome', human.name)
  end

  def winner_if_win
    if human.move.beats?(computer.move)
      return human
    elsif computer.move.beats?(human.move)
      return computer
    end
  end

  def display_results
    prompt('choice', human.name, human.move)
    prompt('choice', computer.name, computer.move)

    winner = winner_if_win
    winner ? prompt('winner', winner.name) : prompt('tie')
  end

  def update_score
    winner = winner_if_win

    if winner
      winner == computer ? computer_score.add : human_score.add
    end
  end

  def display_score
    prompt('score', computer.name, computer_score.count)
    prompt('score', human.name, human_score.count)
  end

  def winner?
    [human_score.count, computer_score.count].max == WINNING_SCORE
  end

  def overall_winner
    if human_score.count == WINNING_SCORE
      return human.name
    end

    computer.name
  end

  def display_winner
    winner = overall_winner

    prompt('overall_winner', winner)
  end

  def display_goodbye
    prompt('exit')
  end
end
