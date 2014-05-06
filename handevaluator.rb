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
      straight_on_board: 0,
      oesd: 0,
      doublegut: 0,
      gutshot: 0,
      pair_plus_gutshot: 0,
      pair_plus_oesd: 0,
      pair_plus_doublegut: 0,
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
#don't want to count pairs if you find a flush etc... need a smart way of merging in result

    #check pairs,straights,flushes and populate madehands
=begin
#use this after pairevaulator.rb done
    pairEvaluator = new PairEvaluator(twoCardHand, @board)
    @madeHands[:total] += 1
    #merge in PairEvaluator.madePairHands

    #mark if there is a pair found to pass into evalstraight
    evalStraight(twoCardHand, @board)
=end
  end

  def evalStraight(twoCardHand, board, hasPair=false)
    fullHand, board = prepareForStraight(twoCardHand, board)
    handStrength = straightStrength(fullHand)
    if handStrength == :straight
      boardStrength = straightStrength(board)
      handStrength = :straight_on_board if boardStrength == :straight
    end
    return if handStrength.nil?
    #@madeHands[handStrength] += 1
    pairPlusStraight(handStrength, hasPair)
    handStrength
    
  end

  def pairPlusStraight(handStrength, hasPair)
    return unless hasPair && (handStrength != :straight)
    pairPlus = ('pair_plus_' + handStrength.to_s).to_sym
    #@madeHands[pairPlus] += 1
    
  end

  def prepareForStraight(twoCardHand, board)
    twoCardHand = twoCardHand.collect {|card| card[:rank]}
    board = board.collect {|card| card[:rank]}
    fullHand = (twoCardHand + board).uniq.sort
    fullHand = wheelFix(fullHand)
    board = wheelFix(board).uniq.sort
    return fullHand, board

  end

  def straightStrength(board)
    diffs = straightDiffs(board)
    straightMatch(diffs)
  end

  def straightMatch(diffs)
    matches = [
      [:straight, [1,1,1,1]],
      [:oesd, [1,1,1]],
      [:doublegut, [2,1,1,2]],
      [:gutshot, [2,1,1]], 
      [:gutshot, [1,2,1]], 
      [:gutshot, [1,1,2]], 
    ]
    found = nil
    matches.each do |m|
      if findSubArray(diffs, m[1]) 
        found = m[0]
        break
      end
    end
    found    
  end

  def findSubArray(hay, needle)
    len = needle.length
    subs = hay.length - len
    return false if subs < 0
    found = false
    (0..subs).each do |i|
      found = true if hay[i,len] == needle 
    end
    found
  end

  def straightDiffs(board)
    len = board.length - 2
    diffs = []
    (0..len).each do |i|
      diffs << board[i+1] - board[i] 
    end    
    diffs
  end

  def wheelFix(hand)
    return hand unless hand.include?(14)
    (hand << 1).sort
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
