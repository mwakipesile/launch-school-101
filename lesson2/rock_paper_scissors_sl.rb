CHOICE_CODES = {
  "r" => "rock",
  "p" => "paper",
  "s" => "scissors",
  "k" => "spock",
  "l" => "lizard"
}.freeze

VALID_CHOICES = CHOICE_CODES.keys.freeze
WIN_COMBOS = %w(sp pr rl lk ks sl lp pk kr rs).freeze
win_count = { player: 0, computer: 0 }

def prompt(message)
  Kernel.puts("=> #{message}")
end

def display_choices
  choices = []
  CHOICE_CODES.each_pair do |code, choice|
    choices << "#{code} for #{choice}"
  end
  prompt("Choose one: Enter #{choices.join(', ')}")
end

def valid_choice?(choice)
  choice if VALID_CHOICES.include?(choice)
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

  return :player if WIN_COMBOS.include?(choices)
  return :computer if WIN_COMBOS.include?(choices.reverse)
end

def wins(count, winner)
  count[winner] += 1 if winner
end

def display_result(winner, player_choice, computer_choice, win_count)
  prompt("You chose: #{player_choice}; Computer chose: #{computer_choice}")

  str = { player: %w(You !), computer: %w(Computer s!) }

  if winner
    prompt("#{str[winner][0]} score#{str[winner][1]} " \
          "You: #{win_count[:player]}, Computer: #{win_count[:computer]}")

    prompt("#{str[winner][0]} won the game!") if win_count[winner] == 5
  else
    prompt('It\'s a tie!')
  end
end

def new_game(message = 'Do you want to play again? Enter Y or N')
  prompt(message)
  answer = Kernel.gets().chomp()
  return true if answer.downcase().start_with?('y')
  return false if answer.downcase().start_with?('n')
  new_game("Wrong choice. Please enter y for Yes, or n for no")
end

def run_rpssl(win_count)
  player = player_choice
  computer = computer_choice

  winner = result(player, computer)
  wins(win_count, winner)
  display_result(winner, CHOICE_CODES[player], CHOICE_CODES[computer], win_count)

  if win_count.values.max < 5 && new_game
    run_rpssl(win_count)
  else
    prompt('Thank you for playing. Good bye!')
  end
end

run_rpssl(win_count)
