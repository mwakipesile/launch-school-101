# frozen_string_literal: true

# Player class
class Player
  MESSAGES = YAML.load_file('player_messages.yml')
  LANGUAGE = 'en'

  attr_accessor :move, :name
end

# Human child class
class Human < Player
  include Helper

  def initialize
    set_name
  end

  def choose
    prompt('choice')
    move_key = gets.chomp.downcase

    if Move::CHOICE_KEYS.include?(move_key)
      self.move = Move.new(move_key)
    else
      prompt('invalid')
      choose
    end
  end
end

# Computer child class
class Computer < Player
  NAMES = %w(Hal Deep\ Blue R2D2 Sonny).freeze

  def initialize
    set_name
  end

  def choose
    self.move = Move.new(Move::CHOICE_KEYS.sample)
  end

  def set_name
    self.name = NAMES.sample
  end
end
