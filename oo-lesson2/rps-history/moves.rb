# frozen_string_literal: true

# Moves class
class Moves
  attr_accessor :data

  def initialize
    results = { freq: 0, won: 0, lost: 0, tie: 0 }
    @data = {
      'rock' => results.dup,
      'paper' => results.dup,
      'scissors' => results.dup
    }
  end

  def track(choice, result = :tie)
    data[choice][:freq] += 1
    data[choice][result] += 1
  end

  def update_wins(choice)
    track(choice, :won)
  end

  def update_losses(choice)
    track(choice, :lost)
  end

  def update_ties(choice)
    track(choice)
  end

  def statistics(choice)
    data[choice]
  end
end
