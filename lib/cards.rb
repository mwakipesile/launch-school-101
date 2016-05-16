CLUB    = '♣'.freeze
DIAMOND = '♦'.freeze
HEART   = '♥'.freeze
SPADE   = '♠'.freeze

SUITS = %w(c d h s).freeze
SUIT_ART = { 'c' => CLUB, 'd' => DIAMOND, 'h' => HEART, 's' => SPADE }.freeze
HIGH_RANKS = %w(T J Q K A).freeze
RANKS = [*'2'..'9'].concat(HIGH_RANKS).freeze
FACE_DOWN = [
  ' _____  ',
  '|XXXXX| ',
  '|XXXXX| ',
  '|XXXXX| ',
  '|XXXXX| ',
  '|XXXXX| '
].freeze

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

def deck_of_cards
  cards = []

  SUITS.each do |suit|
    cards.concat(RANKS.map { |card| card + suit })
  end
  cards
end

def deal(deck, num_cards = 2)
  deck.slice!(0, num_cards)
end

def find_invalid(cards)
  invalid_cards = cards.reject { |card| deck_of_cards.include?(card) }

  return if invalid_cards.empty?

  invalid_cards.join(', ')
end

def display_cards(hand)
  puts '------------------------------------'
  puts hand.join(' ')

  cards = construct_cards(hand)
  # TODO: Limit cards displayed in a row to 8
  cards.each { |block| puts block }
end

def construct_cards(hand)
  cards = Array.new(6, '')
  building_blocks = card_template

  hand.each do |card|
    rank, suit = card.split('')

    if SUIT_ART.key?(suit)
      building_blocks[1] = "|#{rank}    | "
      building_blocks[3] = "|  #{SUIT_ART[suit]}  | "
    else
      building_blocks = FACE_DOWN
    end

    (0..5).each { |i| cards[i] += building_blocks[i] }
  end

  cards
end

def ranks(cards)
  cards = [cards] unless cards.is_a?(Array)
  # TODO: validate/check for duplicate cards
  invalid_cards = find_invalid(cards)

  if invalid_cards
    plurality = invalid_cards.length > 2 ? 's' : ''
    return "Invalid card#{plurality} found: #{invalid_cards}"
  end

  cards.map { |card| card.slice(0) }
end
