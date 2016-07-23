require 'yaml'
require '../../modules/game'
require './player'
require './deck'
require './hand'

# Main Twenty One class
class TwentyOne
  include Helper
  include Game

  LANGUAGE = 'en'.freeze
  MESSAGES = YAML.load_file('twenty_one_messages.yml')
  CARD_POINTS = {
    '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8,
    '9' => 9, 'T' => 10, 'J' => 10, 'Q' => 10, 'K' => 10, 'A' => 11
  }.freeze

  BLACKJACK = 21
  DEALERS_FLOOR_POINTS = 17
  ACE = 'A'.freeze
  HIT = 'h'.freeze
  STAY = 's'.freeze
  HIDDEN_CARD = ''.freeze
  BUSTED = true
  WINNING_COUNT = 3

  attr_reader :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def deal_starting_hands
    player.hand = deck.deal
    dealer.hand = deck.deal
  end

  def deal_card
    deck.deal(1)
  end

  def draw_card
    deck.deal(1)
  end

  def display_status
    dealer.display_status
    player.display_status
  end

  def players_round
    loop do
      display_status

      if player.busted?
        dealer.increment_win_count
        break
      end

      break unless player.hit?
      clear_screen
      player.add_to_hand(deal_card)
    end
  end

  def dealers_round
    dealer.to_reveal_hand

    loop do
      clear_screen
      display_status
      if dealer.busted?
        player.increment_win_count
        break
      end

      break unless dealer.points_below_threshold
      dealer.add_to_hand(draw_card)
    end
  end

  def run_round
    if blackjack?
      natural
    else
      players_round
      dealers_round unless player.busted?
    end

    display_results
  end

  def play
    display_welcome_message(player.name)
    loop do
      deck.shuffle_cards
      deal_starting_hands
      run_round

      break unless new_game
      clear_screen
    end
    display_goodbye_message
  end

  def winner
    if player.points > dealer.points
      player.increment_win_count
      return :player
    elsif dealer.points > player.points
      dealer.increment_win_count
      return :dealer
    end
  end

  def blackjack?
    player.blackjack? || dealer.blackjack?
  end

  def natural
    dealer.to_reveal_hand

    if natural_tie
      display_status
      prompt('push')
    else
      blackjack
    end
  end

  def natural_tie
    player.blackjack? && dealer.blackjack?
  end

  def blackjack
    if player.blackjack?
      player.increment_win_count
      dealer.display_hand
      player.display_blackjack
    else
      dealer.increment_win_count
      dealer.display_blackjack
      player.display_hand
    end
  end

  def display_results
    unless player.busted? || dealer.busted? || blackjack?
      display_showdown_results
    end

    display_win_count
    display_winner if overall_winner
  end

  def display_showdown_results
    case winner
    when :player
      prompt('win', player.name)
    when :dealer
      prompt('win', dealer.name)
    else
      prompt('push')
    end
  end

  def display_win_count
    prompt(
      'win_count',
      player.name,
      player.win_count,
      dealer.name,
      dealer.win_count
    )
  end

  def display_winner
    prompt(overall_winner)
  end

  def game_over?
    overall_winner
  end

  def overall_winner
    return 'player_wins' if player.win_count == WINNING_COUNT
    return 'dealer_wins' if dealer.win_count == WINNING_COUNT
  end

  def reset_win_count
    player.win_count = 0
    dealer.win_count = 0
  end

  def new_game
    reset_win_count if game_over?
    play_again?
  end
end

TwentyOne.new.play
