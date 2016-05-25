# frozen_string_literal: true
# Move class
class Move
  attr_reader :choice

  WIN = {
    'rock' => 'scissors',
    'paper' => 'rock',
    'scissors' => 'paper'
  }.freeze

  CHOICES = WIN.keys.freeze

  def initialize(choice)
    @choice = choice
  end

  def beats?(foe)
    # WIN[choice] == foe.choice ? true : false
    choice == WIN.key(foe.choice) ? true : false
  end

  def to_s
    choice
  end
end
