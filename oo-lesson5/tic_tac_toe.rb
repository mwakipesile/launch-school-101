require 'pry'
require 'yaml'
require '../modules/helper'
require '../modules/game'

# Board Class
class Board
  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
    [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]
  ].freeze

  include Helper

  attr_accessor :squares, :winning_marker

  def initialize
    @squares = empty_squares
  end

  def empty_squares
    (1..9).each.with_object({}) do |pos, squares|
      squares[pos] = Square.new
    end
  end

  def display_row(position1, position2, position3)
    puts '     |     |'
    puts "  #{squares[position1]}  |  " \
      "#{squares[position2]}  |  #{squares[position3]}"
    puts '     |     |'
  end

  def display
    separator = '-----+-----+-----'

    display_row(1, 2, 3)
    puts separator
    display_row(4, 5, 6)
    puts separator
    display_row(7, 8, 9)
  end

  def []=(position, marker)
    squares[position].marker = marker
  end

  def empty_positions
    squares.keys.select do |position|
      position if squares[position].unmarked?
    end
  end

  def full?
    empty_positions.empty?
  end

  def someone_won?
    WINNING_LINES.each do |line|
      return true if detect_winner(line)
    end

    false
  end

  def detect_winner(line)
    square = squares[line.first]
    return false if square.unmarked?

    # if line.map {|position| squares[position].marker }.uniq.size == 1
    if squares.values_at(*line).map(&:marker).uniq.size == 1
      self.winning_marker = square.marker
    end
  end

  def clear
    self.squares = empty_squares
    self.winning_marker = nil
  end
end

# Square class
class Square
  EMPTY_SQUARE = ' '.freeze

  attr_accessor :marker

  def initialize(marker = EMPTY_SQUARE)
    @marker = marker
  end

  def unmarked?
    marker == EMPTY_SQUARE
  end

  def to_s
    marker
  end
end

# Player class
Player = Struct.new(:marker)

# Main Tic Tac Toe class
class TicTacToe
  include Helper
  include Game

  LANGUAGE = 'en'.freeze
  MESSAGES = YAML.load_file('tic_tac_toe_messages.yml')
  CROSS = 'X'.freeze
  NOUGH = 'O'.freeze
  FIRST_TO_MOVE = 'X'.freeze

  attr_reader :board, :human, :computer
  attr_accessor :current_marker

  def initialize
    @board = Board.new
    @human = Player.new(CROSS)
    @computer = Player.new(NOUGH)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    display_welcome_message

    loop do
      loop do
        display_board
        current_player_moves

        break if board.someone_won? || board.full?

        clear_screen
      end

      display_result
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    clear_screen
    prompt('welcome')
  end

  def display_goodbye_message
    prompt('exit')
  end

  def display_board
    prompt('players', human.marker, computer.marker)
    puts ''
    board.display
    puts ''
  end

  def available_positions
    board.empty_positions.join(', ')
  end

  def human_moves
    prompt('choice', available_positions)
    position = nil

    loop do
      position = gets.chomp.to_i
      break if board.empty_positions.include?(position)
      prompt('invalid_square')
    end

    board[position] = human.marker
  end

  def computer_moves
    position = board.empty_positions.sample
    board[position] = computer.marker
  end

  def winner
    return 'You' if board.winning_marker == human.marker
    return 'Computer' if board.winning_marker == computer.marker
  end

  def display_result
    clear_screen
    display_board

    if board.winning_marker
      prompt('winner', winner)
    else
      prompt('tie')
    end
  end

  def current_player_moves
    if current_marker == human.marker
      human_moves
      self.current_marker = computer.marker
    else
      computer_moves
      self.current_marker = human.marker
    end
  end

  def reset
    board.clear
    clear_screen
    self.current_marker = FIRST_TO_MOVE
  end

  def display_play_again_message
    prompt('new_game')
  end
end

game = TicTacToe.new
game.play
