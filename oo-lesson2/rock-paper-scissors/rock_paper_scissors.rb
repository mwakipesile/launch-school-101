# frozen_string_literal: true
require './rock_paper_scissors_base.rb'

class RockPaperScissors < RockPaperScissorsBase
  MESSAGES = YAML.load_file('rock_paper_scissors_messages.yml')
end

RockPaperScissors.new.run
