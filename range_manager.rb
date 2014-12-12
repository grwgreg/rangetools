require './range_parser.rb'

module RangeTools
  class RangeManager
    include RangeParser
    attr_accessor :range

    def initialize
      @range = buildRange
    end

    def buildRange
      ranks = %w(2 3 4 5 6 7 8 9 T J Q K A)
      len = ranks.length
      range = {}
      ranks.each do |right|
        cur = ranks.index(right)
        lefts = ranks.slice(cur..len)
        lefts.each do |left|
          pair = true if left == right
          range[(left + right).to_sym] = _combos(pair)
        end
      end
      range
    end

    def combos
      @combos ||= _combos
    end

    def _combos(pair=false)
      combos = {}
      suits = %w(c d h s)
      suits.each do |lCombo|
        suits.each do |rCombo|
          next if lCombo == rCombo && pair
          combos[(lCombo + rCombo).to_sym] = false
        end
      end
      combos
    end

    def setAll(tag)
      pair = true if tag[0] == tag[1] 
      _combos(pair).each_key do |combo|
        range[tag][combo] = true
      end
    end

    def setSuited(tag)
      suits = [:cc, :dd, :hh, :ss]
      suits.each do |suit|
        range[tag][suit] = true
      end
    end

    def setOffSuited(tag)
      offSuits = combos.keys - [:cc, :dd, :hh, :ss]
      offSuits.each do |offSuit|
        range[tag][offSuit] = true
      end

    end

    def setSingleHand(tag, suits)
      suits.each do |combo|
        range[tag][combo] = true
      end
    end

    def resetAll
      range.each_pair do |tag, combos|
        combos.each_key do |combo|
          range[tag][combo] = false
        end
      end
    end

    def populateRange(rangeString)
      tagBuckets = parseRange(rangeString) 
      resetAll
      processTagBuckets(tagBuckets)
    end

    def processTagBuckets(tagBuckets)
      rangeSetters  = {
        setSingleHand: tagBuckets[:single],
        setOffSuited: tagBuckets[:offsuited],
        setSuited: tagBuckets[:suited],
        setAll: tagBuckets[:both]
      }
      rangeSetters.each_pair do |setter, bucket|
        setAllInBucket(setter, bucket)
      end
    end

    def setAllInBucket(setter, bucket)
      if bucket.is_a?(Hash) then
        bucket.each_pair {|tag, suits| send(setter,tag, suits)}
      else
        bucket.each { |tag| send(setter, tag) }
      end
    end


    def allSet?(hand, type)
      hands = handCombosByType(hand,type)
      hands.all? do |combo, set|
        set 
      end
    end 

    def anySet?(hand, type)
      hands = handCombosByType(hand,type)
      hands.any? do |combo, set|
        set 
      end
    end 

    def getSetCombos(hand, type)
      hands = handCombosByType(hand,type)
      hands.select do |combo, set|
        set 
      end.keys
    end 

    def handCombosByType(hand,type)
      hands = @range[hand]
      if type == :offsuits 
        hands = hands.select do |combo,v| 
          (combos.keys - [:cc, :dd, :hh, :ss]).include?(combo)
        end
      elsif type == :suits
        hands = hands.select do |combo,v| 
          [:cc, :dd, :hh, :ss].include?(combo)
        end
      end
      hands
    end




  end
end
