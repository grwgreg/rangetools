module StraightEvaluator
  extend self

  def evalStraight(twoCardHand, board)
    fullHand, board = prepareForStraight(twoCardHand, board)
    handStrength = straightStrength(fullHand)
    if handStrength == :straight
      boardStrength = straightStrength(board)
      handStrength = :straight_on_board if boardStrength == :straight
    end
    handStrength
=begin
    return if handStrength.nil?
    markMadeHand(handStrength)
    pairPlusStraight(handStrength, hasPair)
    handStrength
=end
    
  end

  private

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

end