module FlushEvaluator
  extend self

  def evalFlush(twoCardHand, board)
    fullHand, board = prepareForFlush(twoCardHand, board)
    {
      fullHand: flushStrength(fullHand),
      board: flushStrength(board)
    }
  end

  private

  def flushStrength(hand)
    suitBuckets = buildSuitBuckets(hand)
    found = nil
    suitBuckets.each_pair do |suit, count|
      if count > 4
        found = :flush
      elsif count > 3
        found = :flush_draw
      end
    end
    found
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
end
