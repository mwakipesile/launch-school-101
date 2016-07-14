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
  WINNING_SCORE = 5

  attr_reader :board, :human, :computer
  attr_accessor :current_marker

  def initialize
    @board = Board.new
    @human = Human.new(choose_marker)
    @computer = Computer.new(computer_marker)
    @current_marker = first_player_to_move
  end

  def first_player_to_move
    return choose_first_player if FIRST_TO_MOVE.casecmp('choose') == 0

    FIRST_TO_MOVE
  end

  def choose_first_player
    options = { '1' => human.marker, '2' => computer.marker }

    prompt('choose_first_player')
    choice = gets.chomp

    return options[choice] if options.key?(choice)

    prompt('invalid_choice')
    choose_first_player
  end

  def choose_marker
    loop do
      prompt('choose_marker')
      marker = gets.chomp

      return CROSS if marker.casecmp(CROSS) == 0
      return NOUGHT if marker.casecmp(NOUGHT) == 0

      prompt('invalid_choice')
    end
  end

  def computer_marker
    return NOUGHT if human.marker == CROSS
    CROSS
  end

  def play
    display_welcome_message

    loop do
      run_the_game
      update_score
      display_results
      display_status

      break if max_score_reached || !new_game
    end

    display_goodbye_message
  end

  private

  def run_the_game
    loop do
      display_board
      current_player_moves

      break if game_over?

      clear_screen
    end
  end

  def display_board
    prompt('players', human.name, human.marker, computer.name, computer.marker)
    board.display
  end

  def game_over?
    board.someone_won? || board.full?
  end

  def winning_player
    return human if board.winning_marker == human.marker
    return computer if board.winning_marker == computer.marker
  end

  def update_score
    winning_player.increment_score if winning_player
  end

  def display_results
    clear_screen
    display_board

    if winning_player
      prompt('winner', winning_player.name)
    else
      prompt('tie')
    end
  end

  def display_status
    prompt('score', human.name, human.score, computer.name, computer.score)

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
      return human.name if human.score == WINNING_SCORE
      return computer.name
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
    self.current_marker = first_player_to_move
  end
end

game = TicTacToe.new
game.play
