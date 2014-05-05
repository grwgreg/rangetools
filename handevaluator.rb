class HandEvaluator
  attr_accessor :board
  attr_accessor :madeHands #what to call this?

  def initialize
    @madeHands = {
      total: 0,
      quads: 0,
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
      #evalHand(twoCardHand)
    end
  end

  def evalHand(twoCardHand)
    #check pairs,straights,flushes and populate madehands
=begin
#use this after pairevaulator.rb done
    pairEvaluator = new PairEvaluator(twoCardHand, @board)
    @madeHands[:total] += 1
    #merge in PairEvaluator.madePairHands
=end
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
    nums = (2..9).collect { |x| x.to_s.to_sym }
    orders = nums + [:T, :J, :Q, :K, :A]
    orders.index(rank) + 2
  end

end
