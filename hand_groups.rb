module RangeTools
class HandGroups
  attr_accessor :rangeManager

  def initialize(hands, rangeManager)
    @rangeManager = rangeManager
    groupHands(hands, :offsuits)
#   groupHands(hands, :suits)
#   groupHands(hands, :all)
  end


  def groupHands(hands, type)
    prevStaged = false
    groupIndex = -1 
    groups = []

    hands.each do |hand|
      all = @rangeManager.allSet?(hand.to_sym, type)
      any = @rangeManager.anySet?(hand.to_sym, type)
      if all && prevStaged
        groups[groupIndex] << hand
      elsif all && !prevStaged
        groups << [hand]
        groupIndex += 1
        prevStaged = true
      elsif any && type == :all
        singleCombos = @rangeManager.getSetCombos(hand.to_sym, type) 
        singles = singleCombos.map do |combo|
          hand.to_s + combo.to_s
        end
        groups << singles#todo greg shouldn't each single be its own group?
        prevStaged = false
        groupIndex += 1
      else 
        prevStaged = false
      end
    end
    groups
  end

end
end
