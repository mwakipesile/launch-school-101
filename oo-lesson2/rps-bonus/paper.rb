require './move.rb'

class Paper < Move
  def initialize
    @choice = :paper
  end

  def beats?(foe)
    foe.choice == Rock.new.choice
  end
end
