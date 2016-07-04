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
    key = gets.chomp.downcase

    if Move::CHOICE_KEYS.include?(key)
      self.move = Move.new.choices[key]
    else
      prompt('invalid')
      choose
    end
  end
end

# Computer child class
class Computer < Player
  attr_accessor :weighed_chances, :moves_count

  NAMES = %w(Hal Deep\ Blue R2D2 Sonny).freeze
  def initialize
    super
    set_name
    @moves_count = 0
  end

  def adjust_chances
    loss_rate = losing_rate

    loss_rate.each.with_object({}) do |(move, rate), chances|
      if rate >= 0.6
        chances[move] = 0.20
      elsif rate >= 0.5
        chances[move] = 0.25
      else
        chances[move] = 0.33
      end
    end
  end

  def losing_rate
    # initiate baseline losing rates
    loss_rate = { 'rock' => 0.33, 'paper' => 0.33, 'scissors' => 0.33 }

    moves.data.each do |move, history|
      wins_losses_total = history[:lost] + history[:won]

      if wins_losses_total > 1
        loss_rate[move] = history[:lost].to_f / wins_losses_total
      end
    end

    loss_rate
  end

  def choose
    moves = Move.new.choices.values
    adjust_chances_every_n_moves(10)
    selector = rand(0.0..weighed_chances.values.inject(:+))
    cutoff = 0
    self.moves_count += 1

    moves.each do |move|
      cutoff += weighed_chances[move.choice]

      if selector <= cutoff
        self.move = move
        break
      end
    end
  end

  def adjust_chances_every_n_moves(num)
    self.weighed_chances = adjust_chances if moves_count % num == 0
  end

  def set_name
    self.name = NAMES.sample
  end
end
