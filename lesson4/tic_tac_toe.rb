require 'yaml'
require '../lesson2/helper_methods.rb'
require './ttt_helper_methods.rb'
require './ttt_computer_methods.rb'

CROSS = 'X'.freeze
NOUGHT = 'O'.freeze
EMPTY_POSITION = ' '.freeze
SWAP_MARKS = { 'X' => NOUGHT, 'O' => CROSS }.freeze
PLAYERS = { 'O' => 'Computer', 'X' => 'You' }.freeze
CORNER_POSITIONS = [0, 2, 6, 8].freeze
EDGE_POSITIONS = [1, 3, 5, 7].freeze
CENTER_POSITION = 4

def lines
  [
    { 0 => EMPTY_POSITION, 1 => EMPTY_POSITION, 2 => EMPTY_POSITION },
    { 6 => EMPTY_POSITION, 7 => EMPTY_POSITION, 8 => EMPTY_POSITION },
    { 0 => EMPTY_POSITION, 3 => EMPTY_POSITION, 6 => EMPTY_POSITION },
    { 2 => EMPTY_POSITION, 5 => EMPTY_POSITION, 8 => EMPTY_POSITION },
    { 0 => EMPTY_POSITION, 4 => EMPTY_POSITION, 8 => EMPTY_POSITION },
    { 2 => EMPTY_POSITION, 4 => EMPTY_POSITION, 6 => EMPTY_POSITION },
    { 3 => EMPTY_POSITION, 4 => EMPTY_POSITION, 5 => EMPTY_POSITION },
    { 1 => EMPTY_POSITION, 4 => EMPTY_POSITION, 7 => EMPTY_POSITION }
  ]
end

winning_lines = lines
board = Array.new(9, EMPTY_POSITION)
available_positions = [*0..8]

def reset_values(board, winning_lines, available_positions)
  winning_lines.clear.concat(lines)
  board.clear.concat(Array.new(9, EMPTY_POSITION))
  available_positions.clear.concat([*0..8])
end

def restart_game(board, winning_lines, available_positions)
  reset_values(board, winning_lines, available_positions)

  run_ttt(board, winning_lines, available_positions)
end

def delete_dead_lines_from(winning_lines)
  winning_lines.delete_if do |hash|
    hash.value?(CROSS) && hash.value?(NOUGHT)
  end
end

def viable_winning_lines(winning_lines)
  delete_dead_lines_from(winning_lines)
end

def win(winning_lines)
  winning_lines.each do |line|
    return CROSS if line.values.all? { |i| i == CROSS }
    return NOUGHT if line.values.all? { |i| i == NOUGHT }
  end

  false
end

def display_board(board)
  horiz = '------------'
  puts '.............'
  puts "  #{board[0]} | #{board[1]}  | #{board[2]}  "
  puts horiz
  puts "  #{board[3]} | #{board[4]}  | #{board[5]}  "
  puts horiz
  puts "  #{board[6]} | #{board[7]}  | #{board[8]}  \n\n"
end

def computer_move(board, winning_lines)
  prompt('computer')
  return CENTER_POSITION if board[CENTER_POSITION] == EMPTY_POSITION

  position = position_from_1_empty_slot_line(winning_lines)
  return position if position

  position_from_2_empty_slots_line(board, winning_lines)
end

def player_move(available_positions, message = 'position')
  prompt(message)
  position = gets.chomp
  position = integer?(position)

  return position - 1 if position && valid_position?(available_positions, position)
  message = 'invalid_position'
  player_move(available_positions, message)
end

def next_position(board, winning_lines, available_positions, mark)
  if mark == CROSS
    position = player_move(available_positions)
  else
    position = computer_move(board, winning_lines)
  end
  position
end

def play(board, winning_lines, available_positions, mark)
  position = next_position(board, winning_lines, available_positions, mark)

  update_available_positions(available_positions, position)

  update_status(board, winning_lines, position, mark)
end

def run_ttt(board, winning_lines, available_positions, mark = CROSS, message = 'welcome')
  prompt(message)

  loop do
    display_board(board)
    play(board, winning_lines, available_positions, mark)

    break if game_over?(winning_lines)
    mark = SWAP_MARKS[mark]
  end

  display_result(board, winning_lines, mark)

  if new_game
    restart_game(board, winning_lines, available_positions)
  else
    prompt('exit')
  end
end

def display_result(board, winning_lines, mark)
  display_board(board)
  if win(winning_lines)
    puts "#{PLAYERS[mark]} won!"
  else
    sleep(0.5)
    prompt('tie')
  end
end

def game_over?(winning_lines)
  win(winning_lines) || viable_winning_lines(winning_lines).empty?
end

def update_status(board, winning_lines, position, mark)
  sleep(1)
  board[position] = mark

  winning_lines.each do |line|
    line[position] = mark if line.key?(position)
  end
end

def new_game(message = 'new')
  prompt(message)
  answer = gets.chomp
  return true if answer.downcase.start_with?('y')
  return false if answer.downcase.start_with?('n')
  new_game('invalid_choice')
end

run_ttt(board, winning_lines, available_positions)
