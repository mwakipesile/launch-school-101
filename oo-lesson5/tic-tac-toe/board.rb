# Board Class
class Board
  CENTER_POSITION = 5
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

  def center_square
    squares[CENTER_POSITION]
  end

  def center_position
    CENTER_POSITION
  end

  def lines_at_immediate_risk
    WINNING_LINES.each.with_object([]) do |line_keys, lines|
      markers = squares.values_at(*line_keys).map(&:marker)

      next unless markers.count(Square::EMPTY_SQUARE) == 1

      lines << line_keys.zip(markers).to_h if markers.uniq.size == 2
    end
  end

  def clear
    self.squares = empty_squares
    self.winning_marker = nil
  end
end
