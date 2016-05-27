# frozen_string_literal: true
require './move_rpssl.rb'
require './player_rpssl.rb'
require '../score.rb'
require '../../modules/game.rb'
require '../rock_paper_scissors_base.rb'

# RPS Spock Lizard class
class RPSSpockLizard < RockPaperScissors
  def initialize
    @human = HumanSL.new
    @computer = ComputerSL.new
  end

  private

  def display_welcome
    prompt("Welcome to Rock, Paper, Scissors, Spock, Lizard challenge #{human.name}!")
  end

  def display_goodbye
    prompt('Thanks for playing Rock, Paper, Scissors, Spock, Lizard. Bye!')
  end
end

RPSSpockLizard.new.run
