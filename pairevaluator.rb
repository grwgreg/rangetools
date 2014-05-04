class PairEvaluator
  attr_accessor :board
  attr_accessor :madePairHands
  attr_accessor :pairBuckets
  attr_reader :done

  def initialize(twoCardHand, board)
    @madePairHands = {
      quads: 0,
      pocket_pair: 0,
      pair: 0,
      two_pair: 0,
      trips: 0,
      full_house: 0,
      ace_high: 0,
      premium_overs: 0, #QJ+ both overs
      mid_pair: 0,
      low_pair: 0,
      high_pair: 0,
      pair_on_board: 0
    }
    @twoCardHand = twoCardHand
    @board = board
    @done = false
    buildPairBuckets(twoCardHand, board)
#    evalPairBuckets
  end

  def evalPairBuckets
    preparePairBuckets
    evalQuads
    evalFullHouse
=begin
    evalTrips
    evalTwoPair
    evalPair
    evalAceHigh(pairBuckets)
    evalPairExtras(twoCardHand, pairBuckets)
=end
  end

  def evalPairExtras
#have @twocardhand and @board for use
    #pocket pair, overcards, needs access to flop and also pairBuckets, only
    #count overcards or ace high as true if no pair+
  end

  def evalQuads
    return unless @pairBuckets[:quads].length
    @madePairHands[:quads] += 1
    @done = true
  end

  def evalFullHouse
    return if @done
    found = false
    if @pairBuckets[:trips].length > 1
      found = true
    elsif @pairBuckets[:trips].length and @pairBuckets[:pairs].length
      found = true
    end
    return unless found
    @madePairHands[:full_house] += 1
    @done = true
  end

  def evalTrips
    return unless @pairBuckets[:trips].length && !@done
    @madePairHands[:trips] += 1
    @done = true
  end

  def evalTwoPair
    return unless @pairBuckets[:pairs].length > 1 && !@done
    @madePairHands[:two_pair] += 1
    @done = true
  end

  def evalPair
    return unless @pairBuckets[:pairs].length && !@done
    @madePairHands[:pair] += 1
    @done = true
    #evalPairType
  end

  def evalPairType
    lcard, rcard = @twoCardHand[0][:rank], @twoCardHand[1][:rank]
    board = @board.collect {|card| card[:rank]}
    if board.include?(lcard) || board.include?(rcard)
      evalPocketPair(lcard, rcard)
      evalOverPair(lcard, rcard)
      evalPairStrength(lcard, rcard)
    else
      @madePairHands[:pair_on_board] += 1
    end 
#check if the pairbucket number matches one of our cards, if not mark pair on board
#if it is, check pocket pair, check premium pocket pair, check overpair
#check mid low etc
  end

  def evalAceHigh
    return unless @pairBuckets[:highs].include?(14) && !@done
    @madePairHands[:ace_high] += 1
  end

  def preparePairBuckets
    replaceTagsWithNumbers
    fixHighCardEdgeCases
  end

  def replaceTagsWithNumbers
    numberBuckets = {}
    pairBuckets.each_pair do |bucket, tags|
      numberBuckets[bucket] = tags.map {|tag| rankNumber(tag)}
    end
    @pairBuckets = numberBuckets
  end

  def rankNumber(rank)
    #greg todo use .to_sym on a range, this si goofy
    orders = [:'2', :'3', :'4', :'5', :'6', :'7', :'8', :'9', :T, :J, :Q, :K, :A]
    orders.index(rank) + 2
  end

  def fixHighCardEdgeCases
    if pairBuckets[:pairs].length > 2
      min = pairBuckets[:pairs].min
      pairBuckets[:highs] << pairBuckets[:pairs].delete(min)
    elsif pairBuckets[:quads].length > 0
      pairBuckets[:highs] += pairBuckets[:trips]
      pairBuckets[:highs] += pairBuckets[:pairs]
    end
  end

  #hand is array of card hashes
  #{suit: :c, rank: 13, tag: :A} => Ac
  def buildPairBuckets(hand, board)
    tags = (hand + board).collect { |card| card[:tag] }
    uniques = tags.uniq
    tagCounts = uniques.collect { |tag| Hash[tag, tags.count(tag)] }
    @pairBuckets = tagCounts.inject(_pairBuckets) { |bucket, tagCount|
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
end
