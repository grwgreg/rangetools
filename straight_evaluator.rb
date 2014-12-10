module RangeTools
  module StraightEvaluator
    extend self

    def evalStraight(twoCardHand, board)
      fullHand, board = prepareForStraight(twoCardHand, board)
      {
        fullHand: straightStrength(fullHand),
        board: straightStrength(board)
      }
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

    def straightStrength(fullhand)
      diffs = straightDiffs(fullhand)
      match = straightMatch(diffs)
      return match unless [:a234_false_positive, :akqj_false_positive].include?(match)
      fixedDiffs = removeEndAce(diffs, match)
      fixedMatch = straightMatch(fixedDiffs)
      if fixedMatch.nil? then fixedMatch = :gutshot end
      fixedMatch
    end

    def removeEndAce(diffs, match)
      if match == :a234_false_positive
        diffs.shift(2)
        diffs
      else
        diffs.pop(2)
        diffs
      end
    end

    def straightMatch(diffs)
      matches = [
        [:straight, [1,1,1,1]],
        [:a234_false_positive, [100,1,1,1]],
        [:akqj_false_positive, [1,1,1,100]],
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
      lowSentinel = -99
      highSentinel = 114 
      (hand << 1 << lowSentinel << highSentinel).sort
    end

  end
end
