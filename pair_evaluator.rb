module RangeTools
  module PairEvaluator
    extend self

    def evalPairHands(twoCardHand, board)
      pairBuckets = buildPairBuckets(twoCardHand, board)
      pairBuckets = preparePairBuckets(pairBuckets)
      evalPairBuckets(pairBuckets, twoCardHand, board)
    end

    private

    def evalPairBuckets(pairBuckets, twoCardHand, board)
      pairHands = {}
      pairValue = findPairValue(pairBuckets)
      pairHands[pairValue] = true if pairValue
      if pairValue == :pair
        pairHands = evalPairType(pairHands, pairBuckets, twoCardHand, board)
      elsif pairValue.nil?
        pairHands = evalOverCards(pairHands, twoCardHand, board)
      end
      pairHands
    end

    def findPairValue(pairBuckets)
      pairValue = nil
      if pairValue = hasQuads(pairBuckets)
      elsif pairValue = hasFullHouse(pairBuckets)
      elsif pairValue = hasTrips(pairBuckets)
      elsif pairValue = hasTwoPair(pairBuckets)
      else pairValue = hasPair(pairBuckets)
      end
      pairValue
    end

    def hasQuads(pairBuckets)
      :quads if pairBuckets[:quads].any?
    end

    def hasFullHouse(pairBuckets)
      found = false
      if pairBuckets[:trips].length > 1
        found = true
      elsif pairBuckets[:trips].any? and pairBuckets[:pairs].any?
        found = true
      end
      :full_house if found
    end

    def hasTrips(pairBuckets)
      :trips if pairBuckets[:trips].any?
    end

    def hasTwoPair(pairBuckets)
      :two_pair if pairBuckets[:pairs].length > 1
    end

    def hasPair(pairBuckets)
      :pair if pairBuckets[:pairs].any?
    end

    def evalPairType(pairHands, pairBuckets, twoCardHand, board)
      lcard, rcard = twoCardRanks(twoCardHand)
      ranks = boardRanks(board)
      if ranks.include?(lcard) || ranks.include?(rcard) || (lcard == rcard)
        pairHands = evalPairStrength(pairHands, pairBuckets)
        pairHands = evalPocketPair(pairHands, lcard, rcard, board)
        pairHands = evalTopPair(pairHands, lcard, rcard, board)
      else
        pairHands[:pair_on_board] = true 
      end 
      pairHands
    end


    def evalTopPair(pairHands, lcard, rcard, board)
      ranks = boardRanks(board)
      if (ranks.include?(lcard) && ranks.max == lcard) \
    || (ranks.include?(rcard) && ranks.max == rcard)
        pairHands[:top_pair] = true 
      end 
      pairHands
    end

    def evalPocketPair(pairHands, lcard, rcard, board)
      if lcard == rcard 
        pairHands[:pocket_pair] = true 
        pairHands[:premium_pocket] = true if lcard > 11#QQ+
        pairHands[:over_pair] = true if boardRanks(board).max < lcard
      end   
      pairHands
    end 

    def evalPairStrength(pairHands, pairBuckets)
      pair = pairBuckets[:pairs].first
      if pair < 7
        pairHands[:low_pair] = true 
      elsif pair < 10
        pairHands[:mid_pair] = true 
      else
        pairHands[:high_pair] = true 
      end
      pairHands
    end

    def evalOverCards(pairHands, twoCardHand, board)
      board = boardRanks(board)
      lcard, rcard = twoCardRanks(twoCardHand)
      if lcard > board.max && rcard > board.max
        pairHands[:over_cards] = true 
      elsif lcard > board.max || rcard > board.max
        pairHands[:one_over_card] = true 
      end
      pairHands[:premium_overs] = true if [lcard, rcard].min > 11
      pairHands[:ace_high] = true if [lcard, rcard].include?(14)
      pairHands
    end

    def preparePairBuckets(pairBuckets)
      replaceTagsWithNumbers(pairBuckets)
    end

    def replaceTagsWithNumbers(pairBuckets)
      numberBuckets = {}
      pairBuckets.each_pair do |bucket, tags|
        numberBuckets[bucket] = tags.map {|tag| rankNumber(tag)}
      end
      numberBuckets
    end

    def rankNumber(rank)
      nums = (2..9).collect { |x| x.to_s.to_sym }
      orders = nums + [:T, :J, :Q, :K, :A]
      orders.index(rank) + 2
    end

    #hand is array of card hashes
    #{suit: :c, rank: 13, tag: :A} => Ac
    def buildPairBuckets(hand, board)
      tags = (hand + board).collect { |card| card[:tag] }
      uniques = tags.uniq
      tagCounts = uniques.collect { |tag| Hash[tag, tags.count(tag)] }
      tagCounts.inject(_pairBuckets) { |bucket, tagCount|
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

    def twoCardRanks(twoCardHand)
      twoCardHand.collect {|card| card[:rank] }
    end

    def boardRanks(board)
      board.collect {|card| card[:rank] }
    end

  end
end
