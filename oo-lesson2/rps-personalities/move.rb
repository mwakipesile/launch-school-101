# frozen_string_literal: true
# Move class
class Move
  attr_reader :choice

  CHOICE_TABLE = {
    'r' => 'rock',
    'p' => 'paper',
    's' => 'scissors'
  }.freeze

  CHOICE_KEYS = %w(r p s).freeze
  WIN = %w(sp pr rs).freeze

  def initialize(choice)
    @choice = choice
  end

  def beats?(foe)
    WIN.include?(choice + foe.choice)
  end

  def to_s
    CHOICE_TABLE[choice]
  end
end
