# frozen_string_literal: true
# Move class
class Move
  attr_reader :choice
  CHOICE_KEYS = %w(r p s).freeze

  def choices
    {
      'r' => Rock.new,
      'p' => Paper.new,
      's' => Scissors.new
    }
  end

  def to_s
    choice
  end
end
