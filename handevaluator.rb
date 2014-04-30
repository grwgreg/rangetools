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

  def evalulateRange(rangeManager)
    twoCardHashes = allTwoCardHashes(rangeManager.range)
    twoCardHashes.each do |twoCardHand|
      evalHand(twoCardHand)
    end
  end

  def evalHand(twoCardHand)
    #check pairs,straights,flushes and populate madehands
  end

  def allTwoCardHashes(range)
    twoCardHands = []
    range.each_pair do |tag, combos|
      twoCardHands += unpackHands(tag, combos)
    end
    twoCardHands
  end

  def unpackHands(tag, combos)
    lRank, rRank = unpackRanks(tag)
    combos.keep_if {|combo, on| on}
    buildCardHashes(lRank, rRank, combos)
  end

  def unpackRanks(tag)
    l, r = tag[0].to_sym, tag[1].to_sym
  end

  def buildCardHashes(lRank, rRank, combos)
    cardHashes = []
    combos.each_key do |combo|
      hand = []
      hand << buildCardHash(lRank, combo, 0)
      hand << buildCardHash(rRank, combo, 1)
      cardHashes << hand
    end
    cardHashes
  end

  def buildCardHash(rank, combo, lOrR)
    {
     suit: combo[lOrR].to_sym,
     rank: rankNumber(rank),
     tag: rank
    }
  end

  def rankNumber(rank)
    orders = [:'2', :'3', :'4', :'5', :'6', :'7', :'8', :'9', :T, :J, :Q, :K, :A]
    orders.index(rank) + 2
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

#should I distinguish between pairs on the board vs in hand? how?
#
#4flush on board vs not? this is less important than pairs becaues obvious from board, same with straight
#i guess pair on board is pretty obvious too? so is trips vs set cause board paired
#i think accounting for pair on board is important maybe an 'only pair on board' count
#
#overcards require comparison though... over pocket pairs too
#
#
#need to account for if you have full house, to not double count pair and trips
#build a new pair hand strength object that has 2pair and quads etc?
#or do sequential checks on pairbuckets?
#
#building a new pair type hand strength obj is probably cleanest, needs side effect
#of popping off results to be worth new hash, 
#
#ie if pairBuckets.pair.lenth >= 3
#    pair_strength[:twopair] << pairBuckets.pair
#    pairBuckets.pair = [] or .empty or whatever ruby method
#
#    except start at strongest hand so don't double count
