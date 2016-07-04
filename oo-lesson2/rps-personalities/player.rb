# frozen_string_literal: true

# Player class
class Player
  MESSAGES = YAML.load_file('../rock-paper-scissors/player_messages.yml')
  LANGUAGE = 'en'

  attr_accessor :move, :moves, :name

  def initialize
    @moves = Moves.new
  end
end

# Human child class
class Human < Player
  include Helper

  def initialize
    super
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
  PLAYERS = {
    'Hal' => { r: 0.20, p: -1, s: 0.80 },
    'Deep Blue' => { r: 0.333, p: 0.333, s: 0.333 },
    'R2D2' => { r: 1.0, p: -1, s: -1 },
    'Sonny' => { r: 0.25, p: 0.50, s: 0.25 }
  }.freeze

  def initialize
    super
    set_name
  end

  def choose
    chances = PLAYERS[name]
    selector = rand

    if selector > (1.0 - chances[:r])
      move_key = 'r'
    elsif selector <= chances[:p]
      move_key = 'p'
    else
      move_key = 's'
    end

    self.move = Move.new(move_key)
  end

  def set_name
    self.name = PLAYERS.keys.sample
  end
end
