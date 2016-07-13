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
