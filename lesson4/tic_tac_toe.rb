require 'pry'
require 'yaml'
require '../lesson2/helper_methods.rb'
require '../lib/game_helpers.rb'
require './ttt_computer_methods.rb'

MESSAGES = YAML.load_file('tic_tac_toe_messages.yml')
LANGUAGE = 'en'.freeze
CROSS = 'X'.freeze
NOUGHT = 'O'.freeze
FIRST_PLAYER = 'choose'.freeze
EMPTY_SQUARE = ' '.freeze
ALTENATE_PLAYERS = { 'X' => NOUGHT, 'O' => CROSS }.freeze
PLAYERS = { 'O' => 'Computer', 'X' => 'You' }.freeze
POSITIONS = [*0..8].freeze
CORNER_POSITIONS = [0, 2, 6, 8].freeze
EDGE_POSITIONS = [1, 3, 5, 7].freeze
CENTER_POSITION = 4

WINNING_LINES = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
  [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]
].freeze

def display_board(board)
  horiz = '------------'
  puts '.............'
  puts "  #{board[0]} | #{board[1]}  | #{board[2]}  "
  puts horiz
  puts "  #{board[3]} | #{board[4]}  | #{board[5]}  "
  puts horiz
  puts "  #{board[6]} | #{board[7]}  | #{board[8]}  \n\n"
end

def first_player
  return choose_first_player if FIRST_PLAYER == 'choose'
  FIRST_PLAYER
end

def choose_first_player
  choices = { '1' => CROSS, '2' => NOUGHT }
  prompt('choose')
  choice = gets.chomp
  return choices[choice] if choice == '1' || choice == '2'
  prompt('invalid')
  choose_first_player
end

def reset(board)
  board.clear.concat(Array.new(9, EMPTY_SQUARE))
end

def empty_positions(board)
  POSITIONS.select { |pos| board[pos] == EMPTY_SQUARE }
end

def valid_position?(board, position)
  position = integer?(position)
  return false unless position

  empty_positions(board).include?(position - 1)
end

def lines_with_path_to_win(board)
  winning_lines_indexes = WINNING_LINES.reject do |indexes|
    line = board.values_at(*indexes)
    line.include?(CROSS) && line.include?(NOUGHT)
  end

  return if winning_lines_indexes.empty?

  winning_lines_indexes.map { |line| Hash[line.zip(board.values_at(*line))] }
end

def viable_winning_lines(board, current_mark)
  winning_lines = lines_with_path_to_win(board)

  return if winning_lines.nil?

  if winning_lines.count == 1
    last_winning_line = winning_lines[0]

    return if last_winning_line.values.count(' ') == 2

    available_positions = empty_positions(board)
    return if available_positions.count < 2 && last_winning_line.value?(current_mark)
  end

  winning_lines
end

def computer_move(board)
  prompt('computer')
  return CENTER_POSITION if board[CENTER_POSITION] == EMPTY_SQUARE

  position = position_at_immediate_risk(board)
  return position if position

  at_risk_position_from_2_empty_slots_line(board)
end

def player_move(board, message = 'position')
  available_positions = empty_positions(board)

  prompt(message)
  puts "=> #{joinor(available_positions)}"

  position = gets.chomp
  position = integer?(position)

  return position - 1 if position && valid_position?(board, position)
  message = 'invalid_position'
  player_move(board, message)
end

def next_position(board, mark)
  return player_move(board) if mark == CROSS

  computer_move(board)
end

def play(board, mark)
  position = next_position(board, mark)

  board[position] = mark
end

def run_the_game(board, mark)
  loop do
    clear_screen

    display_board(board)
    play(board, mark)

    break if win(board)
    break if tie?(board, mark)
    mark = ALTENATE_PLAYERS[mark]
  end
end

def tic_tac_toe(board)
  win_count = { 'X' => 0, 'O' => 0 }
  clear_screen
  prompt('welcome')

  loop do
    mark = first_player
    run_the_game(board, mark)
    winner = win(board)

    win_count[winner] += 1 if winner
    display_result(board, win_count)

    break unless win_count.values.max < 5 && play_again?
    reset(board)
  end

  prompt('exit')
end

def win(board)
  winning_lines = lines_with_path_to_win(board)
  return if winning_lines.nil?

  winning_lines.each do |line|
    return CROSS if line.values.all? { |mark| mark == CROSS }
    return NOUGHT if line.values.all? { |mark| mark == NOUGHT }
  end

  nil
end

def tie?(board, mark)
  viable_winning_lines(board, mark).nil?
end

def display_result(board, win_count)
  display_board(board)
  separator = '---------------------------------------'

  winner = win(board)
  if winner
    puts "#{PLAYERS[winner]} won!"
  else
    sleep(0.5)
    prompt('tie')
  end

  puts separator
  puts "=> Win count. You: #{win_count[CROSS]}, Computer: #{win_count[NOUGHT]}"
  puts separator
end

board = Array.new(9, EMPTY_SQUARE)

tic_tac_toe(board)
