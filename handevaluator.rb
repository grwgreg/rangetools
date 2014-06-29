require('./pairevaluator.rb')
require('./flushevaluator.rb')
require('./straightevaluator.rb')

class HandEvaluator

  def evalHand(board, twoCardHand, madeHands)
    madePairHands, flushStrength, straightStrength = madeHandInfo(twoCardHand, board)
    madeHand = bestMadeHand(flushStrength, straightStrength, madePairHands)
    if madeHand.nil?
      madeHands = markDrawHands(madeHands, madePairHands, straightStrength, flushStrength, twoCardHand) 
    elsif madeHand == :quads_or_full_house
      madeHands = markHands(madePairHands, madeHands, twoCardHand)
    else
      madeHands = markMadeHand(madeHands, madeHand, twoCardHand)
    end
    madeHands
  end

  def madeHandInfo(twoCardHand, board)
    [
      PairEvaluator.evalPairHands(twoCardHand, board),
      FlushEvaluator.evalFlush(twoCardHand, board),
      StraightEvaluator.evalStraight(twoCardHand, board)
    ]
  end

  def markDrawHands(madeHands, madePairHands, straightStrength, flushStrength, twoCardHand)
      hasPair = true if madePairHands[:pair]
      drawHands = madeDrawHands(straightStrength, flushStrength, hasPair)
      madeHands = markHands(drawHands, madeHands, twoCardHand)
      markHands(madePairHands, madeHands, twoCardHand)#ace high, overcards
  end
  
  def bestMadeHand(flushStrength, straightStrength, madePairHands)
    if (flushStrength[:fullHand] == :flush && straightStrength[:fullHand] == :straight)
      :straight_flush
    elsif (madePairHands[:quads] || madePairHands[:full_house])
      :quads_or_full_house
    elsif flushStrength[:fullHand] == :flush
      :flush
    elsif straightStrength[:fullHand] == :straight
      :straight
    end
  end

  def madeDrawHands(straightStrength, flushStrength, hasPair)
    straight, straightBoard = straightStrength[:fullHand], straightStrength[:board]
    flush, flushBoard = flushStrength[:fullHand], flushStrength[:board]
    hands = {
      combo_draw: straight && flush,
      pair_plus_flush_draw: hasPair && (flush == :flush_draw),
      flush_draw_on_board: flushBoard && flushBoard == :flush_draw
    }
    pairPlusX = ('pair_plus_' + straight.to_s).to_sym if straightBoard
    hands[pairPlusX] = hasPair && straight if pairPlusX
    hands[flush] = true if flush
    hands[straight] = true if straight
    hands[(straightBoard.to_s + '_on_board').to_sym] = true if straightBoard
    hands
  end

  def markHands(hands, madeHands, twoCardHand)
    hands.each_pair do |hand, isSet|
      if isSet
        madeHands = markMadeHand(madeHands, hand, twoCardHand)
      end
    end
    madeHands
  end

  def markMadeHand(madeHands, handType, twoCardHand)
    handTag = buildHandTag(twoCardHand)
    madeHands[handType] << handTag
    madeHands
  end

  def buildHandTag(twoCardHand)
    card1, card2 = twoCardHand[0], twoCardHand[1]
    if twoCardHand[0][:rank] < twoCardHand[1][:rank]
      card1, card2 = card2, card1
    end
    r1, r2 = card1[:tag].to_s, card2[:tag].to_s
    s1, s2 = card1[:suit].to_s, card2[:suit].to_s
    r1+r2+s1+s2
  end

end
