module RangeTools
  class HandGroup
    attr_accessor :hands

    def initialize(hands,type=:all)
      @hands = hands
      @typeString = getTypeString(type)
      @singles = hands[0].length == 4
    end

    def setType(type)
      @typeString = getTypeString(type)
      self
    end

    def getTypeString(type)
      {
        suits: 's',
        offsuits: 'o',
        all: '',
      }[type]
    end

    def to_s
      if @singles
        @hands.map {|hand| hand.to_s}.join(',')
      elsif isSpanner?
        @hands.first.to_s + '-' + @hands.last.to_s[1] + @typeString
      else
        @hands.first.to_s + @typeString
      end
    end

    def isSpanner?
      @hands.length > 1
    end

  end
end
