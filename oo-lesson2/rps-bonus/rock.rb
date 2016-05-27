require './move.rb'

class Rock < Move
  def initialize
    @choice = :rock
  end

  def beats?(foe)
    foe.choice == Scissors.new.choice
  end
end
