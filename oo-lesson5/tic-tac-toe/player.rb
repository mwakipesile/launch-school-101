# Player class
class Player
  include Helper
  include StringHelper

  LANGUAGE = 'en'.freeze
  MESSAGES = YAML.load_file('tic_tac_toe_messages.yml')

  attr_accessor :marker, :score

  def initialize(marker, score = 0)
    @marker = marker
    @score = score
  end

  def increment_score
    self.score += 1
  end
end

class Human < Player
  def moves(board)
    prompt('choice', joinor(board.empty_positions, ', ', 'or'))
    position = nil

    loop do
      position = gets.chomp.to_i
      break if board.empty_positions.include?(position)
      prompt('invalid_square')
    end

    board[position] = marker
  end
end

class Computer < Player
  def moves(board)
    if board.center_square.unmarked?
      position = board.center_position
    elsif position = position_at_immediate_risk(board)
    else
      position = board.empty_positions.sample
    end

    board[position] = marker
  end

  def position_at_immediate_risk(board)
    lines = board.lines_at_immediate_risk

    line = lines.find { |winning_line| winning_line.value?(self.marker) }
    line = lines.first unless line

    if line
      markers = line.values
      # risk_square = markers.find { |marker| markers.count(marker) == 1 }
      risk_square = markers.min_by { |marker| markers.count(marker) }
      return line.key(risk_square)
    end
  end
end
