class RangeEvaluator
  attr_accessor :board
  attr_accessor :madeHands #what to call this?

  def initialize(handEvaluator, board)
    @handEvaluator = handEvaluator
    @board = board
    @madeHands = {
      total: 0,
      straight_flush: [],
      quads: [],
      pocket_pair: [],
      premium_pocket: [],
      pair: [],
      straight: [],
#      straight_on_board: [],
      oesd: [],
      doublegut: [],
      gutshot: [],
      pair_plus_gutshot: [],
      pair_plus_oesd: [],
      pair_plus_doublegut: [],
      pair_plus_flush_draw: [],
      flush: [],
      flush_draw: [],
#      flush_on_board: [],
      flush_draw_on_board: [],
      two_pair: [],
      trips: [],
      set: [],
      full_house: [],
      pair_plus_oesd: [],
      pair_plus_gut: [],
      pair_plus_over: [],
      oesd_on_board: [],
      gutshot_on_board: [],
      doublegut_on_board: [],
      combo_draw: [],
      ace_high: [],
      over_cards: [],
      one_over_card: [],
      premium_overs: [],
      mid_pair: [],
      high_pair: [],
      low_pair: [],
      top_pair: [],
      over_pair: [],
      pair_on_board: []
    }
  end

  def evaluateRange(rangeManager)
    twoCardHashes = allTwoCardHashes(rangeManager.range)
    twoCardHashes.each do |twoCardHand|
      @madeHands[:total] += 1
      @madeHands = @handEvaluator.evalHand(@board, twoCardHand, @madeHands)
    end
  end

  def allTwoCardHashes(range)
    twoCardHands = []
    range.each_pair do |tag, combos|
      twoCardHand = unpackHands(tag, combos)
      twoCardHands += removeDeadCards(twoCardHand)
    end
    twoCardHands
  end

  def removeDeadCards(twoCardHand)
    twoCardHand.reject { |hand|
      hand.select { |card|
        @board.include?(card)
      }.any?
    }
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
