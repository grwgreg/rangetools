class PairEvaluator
  attr_accessor :board
  attr_accessor :madePairHands
  attr_accessor :pairBuckets
  attr_accessor :done

  def initialize(twoCardHand, board)
    @madePairHands = {
      quads: 0,
      pocket_pair: 0,
      pair: 0,
      two_pair: 0,
      trips: 0,
      full_house: 0,
      ace_high: 0,
      premium_overs: 0,
      over_cards: 0,
      one_over_card: 0,
      mid_pair: 0,
      low_pair: 0,
      high_pair: 0,
      premium_pocket: 0,
      over_pair: 0,
      pair_on_board: 0
    }
    @twoCardHand = twoCardHand
    @board = board
    @done = false
    buildPairBuckets(twoCardHand, board)
    evalPairBuckets
  end

  def evalPairBuckets
    preparePairBuckets
    evalQuads
    evalFullHouse
    evalTrips
    evalTwoPair
    evalPair
    evalOverCards
  end

  def evalQuads
    return unless @pairBuckets[:quads].any?
    @madePairHands[:quads] += 1
    @done = true
  end

  def evalFullHouse
    return if @done
    found = false
    if @pairBuckets[:trips].length > 1
      found = true
    elsif @pairBuckets[:trips].any? and @pairBuckets[:pairs].any?
      found = true
    end
    return unless found
    @madePairHands[:full_house] += 1
    @done = true
  end

  def evalTrips
    return unless @pairBuckets[:trips].any? && !@done
    @madePairHands[:trips] += 1
    @done = true
  end

  def evalTwoPair
    return unless @pairBuckets[:pairs].length > 1 && !@done
    @madePairHands[:two_pair] += 1
    @done = true
  end

  def evalPair
    return unless @pairBuckets[:pairs].any? && !@done
    @madePairHands[:pair] += 1
    @done = true
    evalPairType
  end

  def evalPairType
    lcard, rcard = twoCardRanks 
    if boardRanks.include?(lcard) || boardRanks.include?(rcard) || (lcard == rcard)
      evalPairStrength
      evalPocketPair(lcard, rcard)
    else
      @madePairHands[:pair_on_board] += 1
    end 
  end

  def evalPocketPair(lcard, rcard)
    if lcard == rcard 
      @madePairHands[:pocket_pair] += 1 
      @madePairHands[:premium_pocket] += 1 if lcard > 11#QQ+
      @madePairHands[:over_pair] += 1 if boardRanks.max < lcard
    end   
  end 

  def evalPairStrength
    pair = @pairBuckets[:pairs].first
    if pair < 7
      @madePairHands[:low_pair] += 1
    elsif pair < 10
      @madePairHands[:mid_pair] += 1
    else
      @madePairHands[:high_pair] += 1
    end
  end

  def evalOverCards
    return if @done
    lcard, rcard = twoCardRanks
    board = boardRanks
    if lcard > board.max && rcard > board.max
      @madePairHands[:over_cards] += 1
    elsif lcard > board.max || rcard > board.max
      @madePairHands[:one_over_card] += 1
    end
    @madePairHands[:premium_overs] += 1 if twoCardRanks.min > 11
    @madePairHands[:ace_high] += 1 if twoCardRanks.include?(14)
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
    nums = (2..9).collect { |x| x.to_s.to_sym }
    orders = nums + [:T, :J, :Q, :K, :A]
    orders.index(rank) + 2
  end

  def fixHighCardEdgeCases
#greg todo, need this for comparing hands but useless for this range evaluator
#because high cards not even evaluated once a pair is found
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

  def twoCardRanks
    @twoCardHand.collect {|card| card[:rank] }
  end

  def boardRanks
    @board.collect {|card| card[:rank] }
  end

end
