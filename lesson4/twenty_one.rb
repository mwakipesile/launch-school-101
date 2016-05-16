require 'yaml'
require '../lesson2/helper_methods.rb'
require '../lib/game_helpers.rb'
require '../lib/cards.rb'

MESSAGES = YAML.load_file('twenty_one_messages.yml')
LANGUAGE = 'en'.freeze
CARD_POINTS = {
  "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8,
  "9" => 9, "T" => 10, "J" => 10, "Q" => 10, "K" => 10, 'A' => 11
}.freeze

BLACKJACK = 21
DEALERS_FLOOR_POINTS = 17
ACE = 'A'.freeze
HIT = 'h'.freeze
STAY = 's'.freeze
HIDDEN_CARD = ''.freeze
BUSTED = true

def blackjack(dealers_hand, players_hand)
  return :player if points(players_hand) == BLACKJACK
  return :dealer if points(dealers_hand) == BLACKJACK
end

def display_blackjack(dealers_hand, players_hand)
  dealers_points = points(dealers_hand)

  clear_screen
  display_cards(dealers_hand)
  prompt('blackjack') if dealers_points == BLACKJACK
  display_cards(players_hand)
  dealers_points == BLACKJACK ? prompt('loss') : prompt('blackjack')
end

def players_round(deck, players_hand, dealers_hand, wins)
  loop do
    clear_screen
    if busted?(players_hand)
      wins[:dealer] += 1
      display_dealers_status(dealers_hand)
      display_players_status(players_hand, BUSTED)
      break
    end

    display_dealers_status([dealers_hand[0], HIDDEN_CARD])
    display_players_status(players_hand)

    updated_hand = update_players_hand(deck, players_hand)
    break unless updated_hand
  end
end

def dealers_round(deck, players_hand, dealers_hand, wins)
  loop do
    updated_hand = update_dealers_hand(deck, dealers_hand)
    busted = busted?(dealers_hand)
    wins[:player] += 1 if busted

    clear_screen
    display_dealers_status(dealers_hand, busted)
    display_players_status(players_hand)
    break if busted || !updated_hand
  end
end

def busted?(players_hand)
  points(players_hand) > BLACKJACK
end

def update_players_hand(deck, players_hand)
  card = card_if_player_hits(deck)
  return if card.nil?
  players_hand.concat(card)
end

def update_dealers_hand(deck, dealers_hand)
  dealers_points = points(dealers_hand)
  card = deal(deck, 1) if dealers_points < DEALERS_FLOOR_POINTS
  return if card.nil?
  dealers_hand.concat(card)
end

def players_decision
  prompt('decision')
  gets.chomp.downcase
end

def points(cards)
  card_ranks = ranks(cards)
  player_points = card_ranks.inject(0) { |sum, rank| sum + CARD_POINTS[rank] }

  card_ranks.each do |rank|
    break unless player_points > BLACKJACK
    player_points -= 10 if rank == ACE
  end

  player_points
end

def card_if_player_hits(deck)
  decision = players_decision

  return deal(deck, 1) if decision.downcase.start_with?(HIT)
  return if decision.downcase.start_with?(STAY)

  prompt('invalid')
  card_if_player_hits(deck)
end

def display_dealers_status(dealers_hand, busted = false)
  display_cards(dealers_hand)
  unless dealers_hand.include?(HIDDEN_CARD)
    puts "=> Dealer #{busted ? 'busted with' : 'stays with'} #{points(dealers_hand)}"
  end
end

def display_players_status(players_hand, busted = false)
  display_cards(players_hand)
  puts "=> #{busted ? 'You busted with' : 'You have'} #{points(players_hand)} points"
end

def winner_if_there_is_one(players_hand, dealers_hand)
  player_points = points(players_hand)
  dealer_points = points(dealers_hand)

  return :player if player_points > dealer_points
  :dealer if dealer_points > player_points
end

def display_result(winner)
  case winner
  when :player
    prompt('win')
  when :dealer
    prompt('loss')
  else
    prompt('push')
  end
end

def run_the_game(deck, players_hand, dealers_hand, wins)
  players_round(deck, players_hand, dealers_hand, wins)
  player_busted = busted?(players_hand)

  dealers_round(deck, players_hand, dealers_hand, wins) unless player_busted

  unless player_busted || busted?(dealers_hand)
    winner = winner_if_there_is_one(players_hand, dealers_hand)
    wins[winner] += 1 if winner
    display_result(winner)
  end

  if wins.values.max == 5
    display_winner(wins)
    reset(wins)
  end
end

def display_winner(wins)
  puts "=> You won #{wins[:player]}, dealer won #{wins[:dealer]}"
  wins[:player] == 5 ? prompt('player_wins') : prompt('dealer_wins')
end

def reset(wins)
  wins[:player] = 0
  wins[:dealer] = 0
end

def twenty_one
  wins = { dealer: 0, player: 0 }

  loop do
    deck = deck_of_cards.shuffle
    dealers_hand = deal(deck)
    players_hand = deal(deck)

    blackjack_winner = blackjack(dealers_hand, players_hand)
    if blackjack_winner
      wins[blackjack_winner] += 1
      display_blackjack(dealers_hand, players_hand)
    else
      run_the_game(deck, players_hand, dealers_hand, wins)
    end

    break unless play_again?
  end
  prompt('exit')
end

twenty_one
