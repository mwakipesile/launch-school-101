require '../../modules/cards'

# Hand class
class Hand
  include Cards

  CARD_POINTS = {
    '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8,
    '9' => 9, 'T' => 10, 'J' => 10, 'Q' => 10, 'K' => 10, 'A' => 11
  }.freeze

  BLACKJACK = 21
  ACE = 'A'.freeze

  def points
    ranks = card_ranks
    hand_points = ranks.inject(0) { |sum, rank| sum + CARD_POINTS[rank] }

    card_ranks.each do |rank|
      break unless hand_points > BLACKJACK
      hand_points -= 10 if rank == ACE
    end

    hand_points
  end

  def blackjack?
    cards.count == 2 && points == BLACKJACK
  end

  def busted?
    points > BLACKJACK
  end
end
