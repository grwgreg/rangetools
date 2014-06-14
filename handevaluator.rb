require('./pairevaluator.rb')
require('./flushevaluator.rb')
require('./straightevaluator.rb')

class HandEvaluator

  def evalHand(board, twoCardHand, madeHands)

    pairEvaluator = PairEvaluator.new(twoCardHand, board)
    madePairHands = pairEvaluator.madePairHands
    hasPair = true if madePairHands[:pair] > 0
    flushStrength = FlushEvaluator.evalFlush(twoCardHand, board)
    straightStrength = StraightEvaluator.evalStraight(twoCardHand, board)

    madeHand = nil
    if (flushStrength == :flush && straightStrength == :straight)
      madeHand = :straight_flush
    elsif (madePairHands[:quads] > 0 || madePairHands[:full_house] > 0)
      madeHand = :quads_or_full_house
    elsif flushStrength == :flush
      madeHand = :flush
    elsif straightStrength == :straight
      madeHand = :straight
    else #do all pair plus logic, including combo draw (straight + flush draw logic)
      madeHands = markDrawsAndCombos(flushStrength, straightStrength, hasPair, madeHands, twoCardHand)
    end

    if !madeHand || madeHand == :quads_or_full_house
      madeHands = mergeMadePairHands(madePairHands, madeHands, twoCardHand)
    else
      madeHands = markMadeHand(madeHand, madeHands, twoCardHand)
    end
    madeHands
  end

  def mergeMadePairHands(madePairHands, madeHands, twoCardHand)
    madePairHands.each_pair do |hand, isSet|
      if !isSet.zero?
        madeHands = markMadeHand(hand, madeHands, twoCardHand)
      end
    end
    madeHands
  end

  def markDrawsAndCombos(flushStrength, straightStrength, hasPair, madeHands, twoCardHand)
    madeHands = pairPlusFlush(flushStrength, hasPair, madeHands, twoCardHand)
    madeHands = pairPlusStraight(straightStrength, hasPair, madeHands, twoCardHand)
    madeHands = markComboDraws(straightStrength, flushStrength, madeHands, twoCardHand)
  end

  def markComboDraws(straightStrength, flushStrength, madeHands, twoCardHand)
    return madeHands unless !straightStrength.nil? && !flushStrength.nil?
    markMadeHand(:combo_draw, madeHands, twoCardHand)
  end

  def pairPlusFlush(handStrength, hasPair, madeHands, twoCardHand)
    return madeHands unless hasPair && (handStrength == :flush_draw)
    markMadeHand(:pair_plush_flush_draw, madeHands, twoCardHand)
  end

  def pairPlusStraight(handStrength, hasPair, madeHands, twoCardHand)
    return madeHands unless hasPair && !handStrength.nil?
    pairPlus = ('pair_plus_' + handStrength.to_s).to_sym
    markMadeHand(pairPlus, madeHands, twoCardHand)
  end


  def markMadeHand(handType, madeHands, twoCardHand)
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
