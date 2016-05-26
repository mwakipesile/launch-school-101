require './move.rb'

class MoveSL < Move
  CHOICE_TABLE = {
    'r' => 'rock',
    'p' => 'paper',
    's' => 'scissors',
    'k' => 'spock',
    'l' => 'lizard'
  }.freeze
  CHOICES = (CHOICE_TABLE.keys).freeze
  WIN = %w(sp pr rl lk ks sl lp pk kr rs).freeze

  def beats?(foe)
    WIN.include?(choice + foe.choice)
  end

  def to_s
    CHOICE_TABLE[choice]
  end
end
