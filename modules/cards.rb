# Deck class
module DeckOfCards
  SUITS = %w(c d h s).freeze
  RANKS = [*'2'..'9'].concat(%w(T J Q K A)).freeze

  attr_accessor :cards

  def initialize
    @cards = deck_of_cards
  end

  def deck_of_cards
    SUITS.each.with_object([]) do |suit, deck|
      deck.concat(RANKS.map { |card| card + suit })
    end
  end

  def shuffle_cards
    self.cards = deck_of_cards.shuffle
  end

  def deal(num_cards = 2)
    cards.slice!(0, num_cards)
  end
end

# Cards class
module Cards
  CLUB    = '♣'.freeze
  DIAMOND = '♦'.freeze
  HEART   = '♥'.freeze
  SPADE   = '♠'.freeze

  SUITS = %w(c d h s).freeze
  RANKS = [*'2'..'9'].concat(%w(T J Q K A)).freeze
  SUIT_ART = { 'c' => CLUB, 'd' => DIAMOND, 'h' => HEART, 's' => SPADE }.freeze
  CARD_FACE_DOWN = [
    ' _____  ',
    '|XXXXX| ',
    '|XXXXX| ',
    '|XXXXX| ',
    '|XXXXX| ',
    '|XXXXX| '
  ].freeze

  attr_accessor :cards, :face_down_cards

  def initialize(cards)
    @cards = cards
    @face_down_cards = 0
  end

  def card_template
    [
      ' _____  ',
      '?',
      '|     | ',
      '?',
      '|     | ',
      '|_____| '
    ]
  end

  def add_another(card)
    cards.concat(card)
  end

  def display
    graphic_cards = construct_cards
    # TODO: Limit cards displayed in a row to 8
    graphic_cards.each { |block| puts block }
  end

  def to_be_revealed
    self.face_down_cards = 0
  end

  def show?
    face_down_cards == 0
  end

  def printable_cards
    return cards if show?
    hidden_hand = cards[0...-face_down_cards]
    face_down_cards.times { hidden_hand << '' }
    hidden_hand
  end

  def construct_cards
    building_blocks = card_template

    cards = printable_cards
    cards.each.with_object(Array.new(6, '')) do |card, graphic_cards|
      rank, suit = card.split('')

      if SUIT_ART.key?(suit)
        building_blocks[1] = "|#{rank}    | "
        building_blocks[3] = "|  #{SUIT_ART[suit]}  | "
      else
        building_blocks = CARD_FACE_DOWN
      end

      (0..5).each { |i| graphic_cards[i] += building_blocks[i] }
    end
  end

  def card_ranks
    self.cards = [cards] unless cards.is_a?(Array)
    cards.map { |card| card.slice(0) }
  end
end
