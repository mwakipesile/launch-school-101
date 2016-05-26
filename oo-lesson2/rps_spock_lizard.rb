# frozen_string_literal: true
require './move_rpssl.rb'
require './player_rpssl.rb'
require './rock_paper_scissors_base.rb'


#RPS Spock Lizard class
class RPSSpockLizard < RockPaperScissors
  def initialize
    @human = HumanSL.new
    @computer = ComputerSL.new
  end
end

RPSSpockLizard.new.run