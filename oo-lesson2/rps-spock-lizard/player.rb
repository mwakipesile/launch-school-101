# frozen_string_literal: true
class Player
  MESSAGES = YAML.load_file('player_messages.yml')
  LANGUAGE = 'en'

  attr_accessor :move, :name
end

# Human class for RPS Spock Lizard
class Human < Player
  include Helper

  def initialize
    set_name
  end

  def choose
    prompt('choice')
    mv = gets.chomp.downcase

    if Move::CHOICES.include?(mv)
      self.move = Move.new(mv)
    else
      prompt('invalid')
      choose
    end
  end
end

# Computer class for RPS Spock Lizard
class Computer < Player
  NAMES = %w(Hal Deep\ Blue R2D2 Sonny).freeze

  def initialize
    set_name
  end

  def choose
    self.move = Move.new(Move::CHOICES.sample)
  end

  def set_name
    self.name = NAMES.sample
  end
end
