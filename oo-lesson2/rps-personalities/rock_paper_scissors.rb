# frozen_string_literal: true
require '../rps-history/rock.rb'
require '../rps-history/paper.rb'
require '../rps-history/scissors.rb'
require '../rps-history/moves.rb'
require '../rock-paper-scissors/rock_paper_scissors_base.rb'

class RockPaperScissors < RockPaperScissorsBase
  MESSAGES = YAML.load_file('../rock-paper-scissors/rock_paper_scissors_messages.yml')
  MOVES = ['rock', 'paper', 'scissors'].freeze

  def run
    display_welcome

    loop do
      human.choose
      computer.choose
      update_history
      display_results
      display_history

      if winner?
        display_winner
        break
      elsif !play_again?
        break
      end
    end

    display_goodbye
  end

  def update_history
    update_score
    winner = winner_if_win

    if winner
      loser = winner == computer ? human : computer

      update_wins_and_losses(winner, loser)
    else
      update_ties
    end
  end

  def update_wins_and_losses(winner, loser)
    winner.moves.update_wins(winner.move.to_s)
    loser.moves.update_losses(loser.move.to_s)
  end

  def update_ties
    human.moves.update_ties(human.move.to_s)
    computer.moves.update_ties(computer.move.to_s)
  end

  def display_history
    prompt('score', computer.name, computer_score.count)
    prompt('score', human.name, human_score.count)

    puts history(human)
    puts history(computer)
  end

  def history(player)
    separator = '-------------------------------------'
    players_history = "#{separator}\n=> #{player.name}'s moves stats\n"

    MOVES.each do |move|
      stats = player.moves.statistics(move)

      players_history += "=> #{move}: #{stats[:won]} wins; " \
        "#{stats[:lost]} losses; #{stats[:tie]} ties\n"
    end

    players_history
  end
end

RockPaperScissors.new.run
