class HandEvaluator
  attr_accessor :board
  attr_accessor :madeHands #what to call this?

  def initialize
    @madeHands = {
      total: 0,
      pocket_pair: 0,
      pair: 0,
      straight: 0,
      oesd: 0,
      gut_shot: 0,
      flush: 0,
      two_pair: 0,
      trips: 0,
      set: 0,
      full_house: 0,
      quads: 0,
      pair_plus_oesd: 0,
      pair_plus_gut: 0,
      pair_plus_over: 0,
      pair_plus_flush: 0,
      ace_high: 0,
      premium_overs: 0, #QJ+ both overs
    }
  end

  #hand is array of card hashes
  #{suit: :c, rank: 13, tag: :A} => Ac
  def buildPairBuckets(hand)
    tags = (hand + @board).collect { |card| card[:tag] }
    uniques = tags.uniq
    tagCounts = uniques.collect { |tag| Hash[tag, tags.count(tag)] }
    tagCounts.inject(_pairBuckets) { |bucket, tagCount|
      tag, count = tagCount.shift
      bucket[whichPairBucket(count)] << tag
      bucket
    }
  end

  def whichPairBucket(count)
    case count
    when 1 then :highs
    when 2 then :pairs
    when 3 then :trips
    when 4 then :quads
    end
  end

  def _pairBuckets
    pairBuckets = {
      highs: [],
      pairs: [],
      trips: [],
      quads: []
    }
  end

=begin
  def evalPockets(hand)
    if hand.length == 2 
      @madeHands[:pocket_pair] += 1
    end
  end
=end
end

#need a method to convert AKcs into hash of Ac and hash of Ks
#should I distinguish between pairs on the board vs in hand? how?
#
#
#method to take range object and iterate through every combo
#for each combo, pass to AKcs to Ac Ks method
#then to main eval method
#build pair buckets
#parse bucket to populate the madehand hash
#
#4flush on board vs not? this is less important than pairs becaues obvious from board, same with straight
#i guess pair on board is pretty obvious too? so is trips vs set cause board paired
#
#overcards require comparison though... over pocket pairs too
