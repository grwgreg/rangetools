module RangeTools
  module RangeFormatter
    extend self

  cards = '23456789TJQKA'.split('').reverse
  @nonPaired = []
  @paired = []

  cards.each do |lCard|
    rCards = cards[(cards.index(lCard) + 1)..-1]
    col = []
    rCards.each do |rCard|
      col << lCard + rCard 
    end
    @nonPaired << col if !col.empty?
  end

  cards.each do |card|
    @paired << card + card
  end

  #puts @nonPaired.inspect

  def formatRange
    rangeStrings = [] 
    @nonPaired.each do |col|
      rangeStrings << handGroups.new(col,self).to_s
    end
  end

  end
end
