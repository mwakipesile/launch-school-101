require 'pry'
require 'yaml'
require '../../modules/helper'
require '../../modules/game'
require '../../modules/string'
require './square'
require './board'
require './player'

# Main Tic Tac Toe class
class TicTacToe
  include Helper
  include Game
  include StringHelper

  LANGUAGE = 'en'.freeze
  MESSAGES = YAML.load_file('tic_tac_toe_messages.yml')
  CROSS = 'X'.freeze
  NOUGHT = 'O'.freeze
  FIRST_TO_MOVE = 'CHOOSE'.freeze
  INITIAL_SCORE = 0
  WINNING_SCORE = 5

  attr_reader :board, :human, :computer
  attr_accessor :current_marker

  def initialize
    @board = Board.new
    @human = Human.new(CROSS, INITIAL_SCORE)
    @computer = Computer.new(NOUGHT, INITIAL_SCORE)
    @current_marker = firs_player_to_move
  end

  def firs_player_to_move
    if FIRST_TO_MOVE.downcase == 'choose'
      return choose_first_player
    end

    FIRST_TO_MOVE
  end

  def choose_first_player
    options = { '1' => CROSS, '2' => NOUGHT }

    prompt('choose_first_player')
    choice = gets.chomp

    return options[choice] if options.key?(choice)

    prompt('invalid_choice')
    choose_first_player
  end



  def play
    display_welcome_message

    loop do
      loop do
        display_board

        current_player_moves

        break if game_over

        clear_screen
      end

      display_result
      break if max_score_reached || !new_game
    end

    display_goodbye_message
  end

  private

  def display_board
    prompt('players', human.marker, computer.marker)
    board.display
  end

  def available_positions
    joinor(board.empty_positions, ', ', 'or')
  end

  def game_over
    board.someone_won? || board.full?
  end

  def winning_player
    if board.winning_marker == human.marker
      human.increment_score
      return 'You'
    elsif board.winning_marker == computer.marker
      computer.increment_score
      return 'Computer'
    end
  end

  def display_result
    clear_screen
    display_board

    if board.winning_marker
      prompt('winner', winning_player)
    else
      prompt('tie')
    end

    prompt('score', human.score, computer.score)

    overall_winner = winner
    prompt('overall_winner', overall_winner) if overall_winner
  end

  def current_player_moves
    if current_marker == human.marker
      human.moves(board)
      self.current_marker = computer.marker
    else
      computer.moves(board)
      self.current_marker = human.marker
    end
  end

  def max_score_reached
    [human.score, computer.score].max == WINNING_SCORE
  end

  def winner
    if max_score_reached
      return 'You are' if human.score == WINNING_SCORE
      return 'Computer is'
    end
  end

  def new_game
    return unless play_again?
    clear_screen
    display_play_again_message
    reset
  end

  def reset
    board.clear
    self.current_marker = firs_player_to_move
  end
end

game = TicTacToe.new
game.play
