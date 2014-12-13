require ('./hand_groups.rb')

module RangeTools
  module RangeFormatter

  def cards
   '23456789TJQKA'.split('').reverse
  end
   
  def nonPaired
    _nonPaired = []#lower left triangle of sklansky table[[AK..A2],[KQ..K2]..]
    cards.each do |lCard|
      rCards = cards[(cards.index(lCard) + 1)..-1]
      col = []
      rCards.each do |rCard|
        col << lCard + rCard 
      end
      _nonPaired << col if !col.empty?
    end
    _nonPaired
  end

  def paired
    _paired = []
    cards.each do |card|
      _paired << card + card
    end
    [_paired]
  end


  def formatRange
    rangeStrings = [] 

    paired.each do |col|
      rangeStrings << HandGroups.new(col,self).to_s
    end

    nonPaired.each do |col|
      rangeStrings << HandGroups.new(col,self).to_s
    end

    rangeStrings.reject {|s| s.empty?}.join(',')
  end

  end
end
