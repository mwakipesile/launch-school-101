require 'pry'
require '../lesson2/helper_methods.rb'
require './ttt_helper_methods.rb'
require './ttt_computer_methods.rb'

SWAP_MARKS = { 'X' => 'O', 'O' => 'X' }.freeze
PLAYERS = { 'O' => 'Computer', 'X' => 'You' }.freeze
CORNER_POSITIONS = [0, 2, 6, 8].freeze

BLANK_WINNING_COMBOS = [
  { 0 => ' ', 1 => ' ', 2 => ' ' },
  { 3 => ' ', 4 => ' ', 5 => ' ' },
  { 6 => ' ', 7 => ' ', 8 => ' ' },
  { 0 => ' ', 3 => ' ', 6 => ' ' },
  { 1 => ' ', 4 => ' ', 7 => ' ' },
  { 2 => ' ', 5 => ' ', 8 => ' ' },
  { 0 => ' ', 4 => ' ', 8 => ' ' },
  { 2 => ' ', 4 => ' ', 6 => ' ' }
].freeze

winning_combos = BLANK_WINNING_COMBOS.dup
board = Array.new(9, ' ')
available_positions = [*0..8]

def reset_game(board, winning_combos, available_positions)
  board.clear.concat(Array.new(9, ' '))
  winning_combos.clear.concat(BLANK_WINNING_COMBOS)
  available_positions.clear.concat([*0..8])
end

def delete_dead_combos_from(winning_combos)
  winning_combos.delete_if do |hash|
    hash.value?('X') && hash.value?('O')
  end
end

def viable_winning_combos(winning_combos)
  delete_dead_combos_from(winning_combos)
end

def win(winning_combos)
  winning_combos.each do |combo|
    return 'X' if combo.values.all? { |i| i == 'X' }
    return 'O' if combo.values.all? { |i| i == 'O' }
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

def computer_move(board, winning_combos)
  puts 'Computer\'s move'
  return 4 if board[4] == ' '

  position = position_from_1_empty_slot_combo(winning_combos)
  return position if position

  position_from_2_empty_slots_combo(winning_combos)
end

def player_move(available_positions, message = 'Your move!')
  puts message
  position = gets.chomp
  position = integer?(position)

  return position - 1 if position && valid_position?(available_positions, position)
  message = 'Invalid position. Try again'
  player_move(available_positions, message)
end

def next_position(board, winning_combos, available_positions, mark)
  if mark == 'X'
    position = player_move(available_positions)
  else
    position = computer_move(board, winning_combos)
  end
  position
end

def play(board, winning_combos, available_positions, mark = 'X')
  loop do
    display_board(board)
    position = next_position(board, winning_combos, available_positions, mark)

    update_available_positions(available_positions, position)

    update_status(board, winning_combos, position, mark)

    break if win(winning_combos) || viable_winning_combos(winning_combos).empty?
    mark = SWAP_MARKS[mark]
  end

  display_board(board)
  if win(winning_combos)
    puts "#{PLAYERS[mark]} won!"
  else
    sleep(0.5)
    puts "It's a tie!"
  end
end

def update_status(board, winning_combos, position, mark)
  sleep(1)
  board[position] = mark

  winning_combos.each do |combo|
    combo[position] = mark if combo.key?(position)
  end
end

play(board, winning_combos, available_positions)
