# frozen_string_literal: true
require '../rock-paper-scissors/rock_paper_scissors_base.rb'

# RPS Spock Lizard class
class RPSSpockLizard < RockPaperScissorsBase
  MESSAGES = YAML.load_file('rps_spock_lizard_messages.yml')
end

RPSSpockLizard.new.run
