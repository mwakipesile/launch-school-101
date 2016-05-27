require './move.rb'

class Scissors < Move
  def initialize
    @choice = :scissors
  end

  def beats?(foe)
    foe.choice == Paper.new.choice
  end
end
