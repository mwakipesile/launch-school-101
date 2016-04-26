require 'pry'
NAME_CODES = { 'rock' => 'r', 'paper' => 'p', 'scissors' => 's', 'spock' => 'k', 'lizard' => 'l' }.freeze
VALID_CHOICES = NAME_CODES.values.freeze
WIN_COMBOS = %w(sp pr rl lk ks sl lp pk kr rs).freeze

def prompt(message)
  Kernel.puts("=> #{message}")
end

def display_choices
  choices = []
  NAME_CODES.each_pair do |name, code|
    choices << "#{code} for #{name}"
  end
  prompt("Choose one: Enter #{choices.join(', ')}")
end

def valid_choice?(choice)
  return choice if VALID_CHOICES.include?(choice)
  false
end

def player_choice
  display_choices
  choice = Kernel.gets().chomp().downcase

  return choice if valid_choice?(choice)
  prompt('That\'s not a valid choice.')
  player_choice
end

def computer_choice
  VALID_CHOICES.sample
end

def result(player, computer)
  choices = "#{player}#{computer}"

  return 'You won!' if WIN_COMBOS.include?(choices)
  return 'Computer won!' if WIN_COMBOS.include?(choices.reverse)
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

def new_game
  prompt('Do you want to play again?')
  answer = Kernel.gets().chomp()
  return true if answer.downcase().start_with?('y')
  false
end

def run_rpssl
  player = player_choice
  computer = computer_choice

  Kernel.puts("You chose: #{NAME_CODES.key(player)}; computer chose: #{NAME_CODES.key(computer)}")

  display_result(player, computer)

  if new_game
    run_rpssl
  else
    prompt('Thank you for playing. Good bye!')
  end
end

run_rpssl
