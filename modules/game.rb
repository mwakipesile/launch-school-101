require_relative './helper'
# Module for reusable game methods
module Game
  def play_again?
    prompt('new') # Helper#prompt from helper.rb

    loop do
      ans = gets.chomp
      return true if ans.downcase.start_with?('y')
      return false if ans.downcase.start_with?('n')
      prompt('invalid')
    end
  end

  def display_play_again_message
    prompt('new_game')
  end
end
