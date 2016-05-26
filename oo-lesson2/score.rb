class Score
  attr_accessor :count

  def initialize
    @count = 0
  end

  def add
    self.count += 1
  end
end