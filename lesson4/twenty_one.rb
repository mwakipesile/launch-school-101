require 'pry'
require 'yaml'
require '../lesson2/helper_methods.rb'
require '../lib/game_helpers.rb'
require '../lib/cards.rb'

CARD_POINTS = {
  "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8,
  "9" => 9, "T" => 10, "J" => 10, "Q" => 10, "K" => 10, 'A' => 11
}.freeze

BLACKJACK = 21
DEALERS_FLOOR_POINTS = 17
ACE = 'A'.freeze
HIT = 'h'.freeze
STAY = 's'.freeze
HIDDEN_CARD = ['', ''].freeze
BUSTED = 'busted'.freeze

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
  puts "Hit or stay?"
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
  return deal(deck, 1) if decision == HIT
  return if decision == STAY
  puts "Invalid input: Please enter H or hit, s or stay"
  card_if_player_hits(deck)
end

def display_dealers_status(dealers_hand, busted = false)
  display_cards(dealers_hand)
  unless dealers_hand.include?(HIDDEN_CARD)
    puts "Dealer #{busted ? 'busted with' : 'stays with'} #{points(dealers_hand)}"
  end
end

def display_players_status(players_hand, busted = false)
  display_cards(players_hand)
  puts "#{busted ? 'You busted with' : 'You have'} #{points(players_hand)} points"
end

def winner_if_there_is_one(players_hand, dealers_hand, wins)
  player_points = points(players_hand)
  dealer_points = points(dealers_hand)

  if player_points > dealer_points
    wins[:player] += 1
    return :player
  elsif dealer_points > player_points
    wins[:dealer] += 1
    return :dealer
  end
end

def display_result(players_hand, dealers_hand, wins)
  winner = winner_if_there_is_one(players_hand, dealers_hand, wins)
  case winner
  when :player
    puts 'You won'
  when :dealer
    puts 'You lost'
  else
    puts 'Push'
  end
end

def display_winner(wins)
  puts "You won #{wins[:player]}, dealer won #{wins[:dealer]}"
  winner = wins[:player] == 5 ? 'You are' : 'Dealer is'
  puts "#{winner} the overall winner"
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

    players_round(deck, players_hand, dealers_hand, wins)
    player_busted = busted?(players_hand)

    dealers_round(deck, players_hand, dealers_hand, wins) unless player_busted

    busted = player_busted || busted?(dealers_hand)
    display_result(players_hand, dealers_hand, wins) unless busted

    if wins.values.max == 5
      display_winner(wins)
      reset(wins)
    end

    break unless play_again?
  end
end

twenty_one
