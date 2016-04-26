require 'pry'
VALID_CHOICES = %w(rock paper scissors).freeze

def prompt(message)
  Kernel.puts("=> #{message}")
end

def result(player, computer)
  choices = [player, computer]
  winning_combinations = [%w(paper rock), %w(scissors paper), %w(rock scissors)]

  return 'You won!' if winning_combinations.include?(choices)
  return 'Computer won!' if winning_combinations.include?(choices.reverse)
  false
end

def display_result(player, computer)
  winner = result(player, computer)
  if winner
    prompt(winner)
  else
    prompt('It\'s a tie!')
  end
end

loop do
  choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = Kernel.gets().chomp()

    break if VALID_CHOICES.include?(choice)
    prompt('That\'s not a valid choice.')
  end

  computer_choice = VALID_CHOICES.sample

  Kernel.puts("You chose: #{choice}; computer chose: #{computer_choice}")

  display_result(choice, computer_choice)

  prompt('Do you want to play again?')
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt('Thank you for playing. Good bye!')
