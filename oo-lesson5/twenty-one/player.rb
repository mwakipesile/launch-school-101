require 'pry'
# Players parent class
class Gambler
  include Helper

  LANGUAGE = 'en'.freeze
  MESSAGES = YAML.load_file('twenty_one_messages.yml')
  HIT = 'h'.freeze
  STAY = 's'.freeze

  attr_reader :hand
  attr_accessor :points, :hit, :stay, :win_count

  def initialize
    @win_count = 0
  end

  def hand=(cards)
    @hand = Hand.new(cards)
  end

  def display_hand
    hand.display
  end

  def hit?
    loop do
      prompt('decision')
      decision = gets.chomp.downcase

      return true if decision.downcase.start_with?(HIT)
      return false if decision.downcase.start_with?(STAY)

      prompt('invalid')
    end
  end

  def add_to_hand(card)
    hand.add_another(card)
  end

  def points
    hand.points
  end

  def blackjack?
    hand.blackjack?
  end

  def display_blackjack
    hand.display
    prompt('blackjack', name)
  end

  def busted?
    hand.busted?
  end

  def increment_win_count
    self.win_count += 1
  end
end

# Player class
class Player < Gambler
  attr_accessor :name

  def initialize
    super
    set_name
  end

  def display_status
    hand.display

    if blackjack?
      prompt('natural')
    elsif busted?
      prompt('bust', name, points)
    else
      prompt('points', name, points)
    end
  end
end

# Dealer class
class Dealer < Gambler
  FLOOR_POINTS = 17
  FACE_DOWN_CARDS = 1

  attr_reader :name

  def initialize
    super
    @name = 'Dealer'
  end

  def hand=(cards)
    @hand = Hand.new(cards)
    hand.face_down_cards = FACE_DOWN_CARDS
  end

  def display_status
    hand.display

    if blackjack?
      prompt('natural')
    elsif hand.show?
      if busted?
        prompt('bust', name, points)
      else
        prompt('stay', name, points)
      end
    end
  end

  def to_reveal_hand
    hand.to_be_revealed
  end

  def points_below_threshold
    points < FLOOR_POINTS
  end
end
