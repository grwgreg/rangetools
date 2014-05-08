class HandEvaluator
  attr_accessor :board
  attr_accessor :madeHands #what to call this?
  attr_accessor :twoCardHand

  def initialize
    @madeHands = {
      total: 0,
      quads: [],
      pocket_pair: [],
      pair: [],
      straight: [],
      straight_on_board: [],
      oesd: [],
      doublegut: [],
      gutshot: [],
      pair_plus_gutshot: [],
      pair_plus_oesd: [],
      pair_plus_doublegut: [],
      pair_plus_flush_draw: [],
      flush: [],
      flush_draw: [],
      flush_on_board: [],
      flush_draw_on_board: [],
      two_pair: [],
      trips: [],
      set: [],
      full_house: [],
      pair_plus_oesd: [],
      pair_plus_gut: [],
      pair_plus_over: [],
      pair_plus_flush: [],
      ace_high: [],
      premium_overs: [], #QJ+ both overs
#make a pair plus over?
    }
  end

  def evalulateRange(rangeManager)
    twoCardHashes = allTwoCardHashes(rangeManager.range)
    twoCardHashes.each do |twoCardHand|
      @twoCardHand = twoCardHand
      #evalHand(twoCardHand)
    end
  end

  def evalHand(twoCardHand)
  #first check pairevaluator, if quads or full house then break, otherwise mark if 
  #we have a pair and pass that along to eval flush and eval straight
  #if neither flush or straight then merge in the paireval's object for overcards etc


=begin
    @madeHands[:total] += 1
    pairEvaluator = new PairEvaluator(twoCardHand, @board)
    madePairHands = pairEvaluator.madePairHands
    hasPair = true if madePairHands[:pair] > 0
    flushStrength = evalFlush(twoCardHand, board, hasPair)
    straightStrength = evalStraight(twoCardHand, board, hasPair)

    if flush & straight
    if quads || full house, mergepairhands
    if flush merge flush
    merge pairhands

    wait, flush and straight merge automatically just by being ran...

    this really needs to be another class which returns a hash like pairhandevaluator

=end
  end

  def markMadeHand(handType)
    handTag = buildHandTag(@twoCardHand)
    @madeHands[handType] << handTag
  end

  def buildHandTag(twoCardHand)
    if twoCardHand[0][:rank] < twoCardHand[1][:rank]
      card1 = twoCardHand[1]
      card2 = twoCardHand[0]
    else
      card1 = twoCardHand[0]
      card2 = twoCardHand[1]
    end
    r1 = card1[:tag].to_s
    r2 = card2[:tag].to_s
    s1 = card1[:suit].to_s
    s2 = card2[:suit].to_s
    r1+r2+s1+s2
  end

  def evalFlush(twoCardHand, board, hasPair=false)
    fullHand, board = prepareForFlush(twoCardHand, board)
    handStrength = flushStrength(fullHand)
    boardStrength = flushStrength(board)
    if handStrength == :flush
      handStrength = :flush_on_board if boardStrength == :flush
    elsif handStrength == :flush_draw
      handStrength = :flush_draw_on_board if boardStrength == :flush
    end
    return if handStrength.nil?
    markMadeHand(handStrength)
    pairPlusFlush(handStrength, hasPair)
    handStrength
    
  end

  def flushStrength(hand)
    suitBuckets = buildSuitBuckets(hand)
    found = nil
    suitBuckets.each_pair do |suit, count|
      if count > 4
        found = :flush
      elsif count > 3
        found = :flush_draw
      end
    found
    end

  end

  def pairPlusFlush(handStrength, hasPair)
    return unless hasPair && (handStrength == :flush_draw)
    markMadeHand(:pair_plush_flush_draw)
    
  end

  def buildSuitBuckets(fullHand)
    fullHand.inject({}) do |suitBuckets, suit|
      suitBuckets[suit] ||= 0
      suitBuckets[suit] += 1
      suitBuckets
    end
  end

  def prepareForFlush(twoCardHand, board)
    twoCardHand = twoCardHand.collect {|card| card[:suit]}
    board = board.collect {|card| card[:suit]}
    fullHand = (twoCardHand + board)
    [fullHand, board]
  end

  def evalStraight(twoCardHand, board, hasPair=false)
    fullHand, board = prepareForStraight(twoCardHand, board)
    handStrength = straightStrength(fullHand)
    if handStrength == :straight
      boardStrength = straightStrength(board)
      handStrength = :straight_on_board if boardStrength == :straight
    end
    return if handStrength.nil?
    markMadeHand(handStrength)
    pairPlusStraight(handStrength, hasPair)
    handStrength
    
  end

  def pairPlusStraight(handStrength, hasPair)
    return unless hasPair && (handStrength != :straight)
    pairPlus = ('pair_plus_' + handStrength.to_s).to_sym
    markMadeHand(pairPlus)
    
  end

  def prepareForStraight(twoCardHand, board)
    twoCardHand = twoCardHand.collect {|card| card[:rank]}
    board = board.collect {|card| card[:rank]}
    fullHand = (twoCardHand + board).uniq.sort
    fullHand = wheelFix(fullHand)
    board = wheelFix(board).uniq.sort
    [fullHand, board]

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

#im starting to think this needs another class, one for each 2 card hand instance
#otherwise you either have to pass extra arguments around for every single function
#or have an instance variable that changes every hand and is annoying and hard to test
