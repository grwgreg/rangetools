class Deck
  attr_accessor :cards
  def initialize
    @cards = buildDeck
  end

  def buildDeck
    new_deck = []
    readable_tags = %w(T J Q K A)
    (2..14).to_a.each do |rank|
      tag = rank
      unless rank < 10
        tag = readable_tags[rank-10]
      end
      %w(c d h s).each do |suit|
        card = {}
        card[:suit] = suit
        card[:rank] = rank
        card[:tag] = tag
        new_deck << card
      end
    end
    new_deck
  end

  def shuffle!
    @cards.shuffle!
  end
end
