require './player.rb'

#Human class for RPS Spock Lizard
class HumanSL < Human
  def choose
    puts 'Enter r, p, s, k, or l for rock, paper,' \
      'scissors, spock, or lizard respectively'
    mv = gets.chomp.downcase

    if MoveSL::CHOICES.include?(mv)
      self.move = MoveSL.new(mv)
    else
      puts "Incorrect move"
      choose
    end
  end
end

# Computer class for RPS Spock Lizard
class ComputerSL < Computer
  def choose
    self.move = MoveSL.new(MoveSL::CHOICES.sample)
  end
end