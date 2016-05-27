# frozen_string_literal: true
# Move class
class Move
  attr_reader :choice, :rock, :paper, :scissors
  CHOICE_KEYS = %w(r p s).freeze

  def initialize
    @rock = Rock.new
    @paper = Paper.new
    @scissors = Scissors.new
  end

  def choices
    {
      'r' => rock,
      'p' => paper,
      's' => scissors
    }
  end

  def to_s
    choice.to_s
  end
end
