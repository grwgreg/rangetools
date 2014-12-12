require './hand_evaluator.rb'

module RangeTools
  class RangeEvaluator
    include HandEvaluator
    attr_accessor :board
    attr_accessor :madeHands

    def initialize(board)
      @board = buildBoard(board)
      @draws = {
        oesd: [],
        doublegut: [],
        gutshot: [],
        pair_plus_gutshot: [],
        pair_plus_oesd: [],
        pair_plus_doublegut: [],
        pair_plus_flush_draw: [],
        flush_draw: [],
        flush_draw_on_board: [],
        pair_plus_oesd: [],
        pair_plus_gut: [],
        pair_plus_over: [],
        oesd_on_board: [],
        gutshot_on_board: [],
        doublegut_on_board: [],
        combo_draw: [],
        over_cards: [],
        one_over_card: [],
        premium_overs: [],
      }
      @madeHands = {
        total: 0,
        straight_flush: [],
        quads: [],
        pocket_pair: [],
        premium_pocket: [],
        pair: [],
        straight: [],
        flush: [],
        two_pair: [],
        trips: [],
        full_house: [],
        ace_high: [],
        mid_pair: [],
        high_pair: [],
        low_pair: [],
        top_pair: [],
        over_pair: [],
        pair_on_board: []
      }.merge(@draws)
    end

    def buildBoard(board)
      #should there be some validation???
      #just wrap in a try?
      if board.is_a? String
        board.split(',').map do |tag| 
          card = tag.split('')
          {
            tag: card[0].to_sym,
            rank: rankNumber(card[0].to_sym),
            suit: card[1]
          }
        end
      elsif board.is_a? Array
        board
      end
    end

    def evaluateRange(range)
      twoCardHashes = allTwoCardHashes(range)
      twoCardHashes.each do |twoCardHand|
        @madeHands[:total] += 1
        @madeHands = evalHand(@board, twoCardHand, @madeHands)
      end
    end

    def rangeReport
      statistics.each_with_object({}) do |hands,report|
        hand_type = hands[0]
        report[hand_type] = {
          percent: hands[1],
          hands: @madeHands[hand_type]
        }
      end
    end

    def statistics
      total = @madeHands[:total].to_f
      @madeHands.each_with_object({}) do |made,stats|
        count = made[1].kind_of?(Array) ? made[1].length : 0
        next if made[0] == :total
        next if @board.length == 5 && @draws.has_key?(made[0])
        stats[made[0]] = count.to_f / total 
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
end
