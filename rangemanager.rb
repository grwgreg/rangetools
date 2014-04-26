class RangeManager
  attr_accessor :range
  def initialize
    @range = buildRange
  end

  def buildRange
    ranks = %w(2 3 4 5 6 7 8 9 T J Q K A)
    len = ranks.length
    range = {}
    ranks.each do |right|
      cur = ranks.index(right)
      lefts = ranks.slice(cur..len)
      lefts.each do |left|
        pair = true if left == right
        range[(left + right).to_sym] = _combos(pair)
      end
    end
    range
  end

  def combos
    @combos ||= _combos
  end

  def _combos(pair=false)
    combos = {}
    suits = %w(c d h s)
    suits.each do |lCombo|
      suits.each do |rCombo|
        next if lCombo == rCombo && pair
        combos[(lCombo + rCombo).to_sym] = false
      end
    end
    combos
  end

  def setAll(tag)
   combos.each_key do |combo|
     @range[tag][combo] = true
   end
  end

  def setSuited(tag)
    suits = [:cc, :dd, :hh, :ss]
    suits.each do |suit|
      @range[tag][suit] = true
    end
  end

  def setOffSuited(tag)
    offSuits = combos.keys - [:cc, :dd, :hh, :ss]
    offSuits.each do |offSuit|
      @range[tag][offSuit] = true
    end

  end

  def setSingleHand(hand)
    hand = hand.shift
    tag = hand[0]
    suits = hand[1]
    suits.each do |combo|
      @range[tag][combo] = true
    end
  end

  #make method that takes tagBuckets, calls each of the above methods on each
  #then make method that takes the rangeparser object, gets the tagbuckets and invokes above
end
