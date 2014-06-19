require('./pairevaluator.rb')
require('./flushevaluator.rb')
require('./straightevaluator.rb')

class HandEvaluator

  def evalHand(board, twoCardHand, madeHands)

    madePairHands = PairEvaluator.evalPairHands(twoCardHand, board)
    flushStrength = FlushEvaluator.evalFlush(twoCardHand, board)
    straightStrength = StraightEvaluator.evalStraight(twoCardHand, board)

    madeHand = nil
    if (flushStrength == :flush && straightStrength == :straight)
      madeHand = :straight_flush
    elsif (madePairHands[:quads] || madePairHands[:full_house])
      madeHand = :quads_or_full_house
    elsif flushStrength == :flush
      madeHand = :flush
    elsif straightStrength == :straight
      madeHand = :straight
    else #do all pair plus logic, including combo draw (straight + flush draw logic)
      hasPair = true if madePairHands[:pair]
      drawHands = madeDrawHands(straightStrength, flushStrength, hasPair)
      madeHands = markHands(drawHands, madeHands, twoCardHand)
    end

    if !madeHand || madeHand == :quads_or_full_house
      madeHands = markHands(madePairHands, madeHands, twoCardHand)
    else
      madeHands = markMadeHand(madeHands, madeHand, twoCardHand)
    end
    madeHands
  end

  def madeDrawHands(straightStrength, flushStrength, hasPair)
    hands = {
      combo_draw: straightStrength && flushStrength,
      pair_plus_flush_draw: hasPair && (flushStrength == :flush_draw)
    }
    pairPlusX = ('pair_plus_' + straightStrength.to_s).to_sym
    hands[pairPlusX] = hasPair && straightStrength if straightStrength
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

end
