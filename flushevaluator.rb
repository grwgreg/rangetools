module FlushEvaluator
  extend self
  #put main method here

  def evalFlush(twoCardHand, board)
    fullHand, board = prepareForFlush(twoCardHand, board)
    handStrength = flushStrength(fullHand)
    boardStrength = flushStrength(board)
    if handStrength == :flush
      handStrength = :flush_on_board if boardStrength == :flush
    elsif handStrength == :flush_draw
      handStrength = :flush_draw_on_board if boardStrength == :flush_draw
    end
    handStrength
  end

  private
  #put eerything else here

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

=begin
  def pairPlusFlush(handStrength, hasPair)
    return unless hasPair && (handStrength == :flush_draw)
    #markMadeHand(:pair_plush_flush_draw)
    
  end
=end

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
