require 'yaml'
require '../lesson2/helper_methods.rb'
require './ttt_computer_methods.rb'

CROSS = 'X'.freeze
NOUGHT = 'O'.freeze
FIRST_PLAYER = 'choose'.freeze
EMPTY_POSITION = ' '.freeze
ALTENATE_PLAYERS = { 'X' => NOUGHT, 'O' => CROSS }.freeze
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

def reset_values(board, winning_lines, available_positions)
  winning_lines.clear.concat(lines)
  board.clear.concat(Array.new(9, EMPTY_POSITION))
  available_positions.clear.concat([*0..8])
end

def valid_position?(available_positions, position)
  position = integer?(position)
  return false unless position
  available_positions.include?(position - 1)
end

def update_available_positions(available_positions, used_position)
  available_positions.delete(used_position)
end

def delete_dead_lines_from(winning_lines)
  winning_lines.delete_if do |line|
    line.value?(CROSS) && line.value?(NOUGHT)
  end
end

def viable_winning_lines(winning_lines, positions, current_mark)
  delete_dead_lines_from(winning_lines)

  return if winning_lines.empty?

  if winning_lines.count == 1
    return if winning_lines[0].values.count(' ') == 2
    return if positions.count < 2 && winning_lines[0].value?(current_mark)
  end

  winning_lines
end

def computer_move(board, winning_lines)
  prompt('computer')
  return CENTER_POSITION if board[CENTER_POSITION] == EMPTY_POSITION
  position = position_at_immediate_risk(winning_lines)
  return position if position

  at_risk_position_from_2_empty_slots_line(board, winning_lines)
end

def player_move(available_positions, message = 'position')
  prompt(message)
  puts "=> #{joinor(available_positions)}"

  position = gets.chomp
  position = integer?(position)

  return position - 1 if position && valid_position?(available_positions, position)
  message = 'invalid_position'
  player_move(available_positions, message)
end

def next_position(board, winning_lines, available_positions, mark)
  return player_move(available_positions) if mark == CROSS

  computer_move(board, winning_lines)
end

def play(board, winning_lines, available_positions, mark)
  position = next_position(board, winning_lines, available_positions, mark)
  update_available_positions(available_positions, position)

  update_status(board, winning_lines, position, mark)
end

def run_the_game(board, winning_lines, available_positions, mark)
  loop do
    clear_screen

    display_board(board)
    play(board, winning_lines, available_positions, mark)

    break if win(winning_lines)
    break if tie?(winning_lines, available_positions, mark)
    mark = ALTENATE_PLAYERS[mark]
  end
end

def tic_tac_toe(board, winning_lines, available_positions)
  win_count = { 'X' => 0, 'O' => 0 }
  prompt('welcome')

  loop do
    mark = first_player
    run_the_game(board, winning_lines, available_positions, mark)
    winner = win(winning_lines)
    win_count[winner] += 1 if winner
    display_result(board, winning_lines, win_count)

    break unless win_count.values.max < 5 && new_game
    reset_values(board, winning_lines, available_positions)
  end

  prompt('exit')
end

def update_status(board, winning_lines, position, mark)
  sleep(0.5)
  board[position] = mark

  winning_lines.each do |line|
    line[position] = mark if line.key?(position)
  end
end

def win(winning_lines)
  winning_lines.each do |line|
    return CROSS if line.values.all? { |i| i == CROSS }
    return NOUGHT if line.values.all? { |i| i == NOUGHT }
  end

  false
end

def tie?(winning_lines, positions, mark)
  viable_winning_lines(winning_lines, positions, mark).nil?
end

def display_result(board, winning_lines, win_count)
  display_board(board)
  separator = '---------------------------------------'

  winner = win(winning_lines)
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

def new_game(message = 'new')
  prompt(message)
  answer = gets.chomp
  clear_screen
  return true if answer.downcase.start_with?('y')
  return false if answer.downcase.start_with?('n')
  new_game('invalid_choice')
end

tic_tac_toe(board, winning_lines, available_positions)
