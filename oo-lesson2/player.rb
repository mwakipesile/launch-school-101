# frozen_string_literal: true
# Player class
class Player
  attr_accessor :move, :name
end

# Human child class
class Human < Player
  def initialize
    set_name
  end

  def choose
    puts 'Choose rock, paper, or scissors'
    mv = Move.new(gets.chomp)

    if Move::CHOICES.include?(mv.choice)
      self.move = mv
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
    set_name
  end

  def choose
    self.move = Move.new(Move::CHOICES.sample)
  end

  def set_name
    self.name = NAMES.sample
  end
end
