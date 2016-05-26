# frozen_string_literal: true
# Player class
class Player
  attr_accessor :move, :name, :score

  def initialize
    @score = Score.new
  end
end

# Human child class
class Human < Player
  def initialize
    super
    set_name
  end

  def choose
    puts 'Enter r, p, or s for rock, paper, or scissors respectively'
    mv = gets.chomp.downcase

    if Move::CHOICES.include?(mv)
      self.move = Move.new(mv)
    else
      puts "Incorrect move"
      choose
    end
  end

  def set_name
    puts 'Please enter your name'
    nm = gets.chomp

    if nm.empty?
      puts "Sorry, must enter value"
      set_name
    else
      self.name = nm
    end
  end
end

# Computer child class
class Computer < Player
  NAMES = %w(Hal Deep\ Blue R2D2 Sonny).freeze

  def initialize
    super
    set_name
  end

  def choose
    self.move = Move.new(Move::CHOICES.sample)
  end

  def set_name
    self.name = NAMES.sample
  end
end
