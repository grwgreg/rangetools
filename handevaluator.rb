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
    if (flushStrength == :flush && straightStrength == :straight)
      :straight_flush
    elsif (madePairHands[:quads] || madePairHands[:full_house])
      :quads_or_full_house
    elsif flushStrength == :flush
      :flush
    elsif straightStrength == :straight
      :straight
    end
  end

  def madeDrawHands(straightStrength, flushStrength, hasPair)
    hands = {
      combo_draw: straightStrength && flushStrength,
      pair_plus_flush_draw: hasPair && (flushStrength == :flush_draw)
    }
    pairPlusX = ('pair_plus_' + straightStrength.to_s).to_sym if straightStrength != :straight_on_board
    hands[pairPlusX] = hasPair && straightStrength if straightStrength && pairPlusX
    hands[flushStrength] = true if flushStrength
    hands[straightStrength] = true if straightStrength
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
