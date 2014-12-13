require './hand_group.rb'

module RangeTools
class HandGroups
  attr_accessor :rangeManager
  attr_accessor :groups

  def initialize(hands, rangeManager)
    @rangeManager = rangeManager
    @groups = buildGroups(hands)
  end

  def buildGroups(hands)
    offsuits = groupHands(hands, :offsuits)
    suits = groupHands(hands, :suits)
    @both = inBothGroups(suits, offsuits)
    @offsuits = removeDuplicates(offsuits, @both)
    @suits = removeDuplicates(suits, @both)

    @both + @suits + @offsuits
  end

  def to_s
    @groups.join(',')
  end


  def inBothGroups(suits, offsuits)
    suits.reduce([]) do |both, group|
      found = false
      offsuits.each do |ogroup|
        found ||= ogroup.hands == group.hands
      end
      both << group.setType(:all) if found
      both 
    end
  end
  #todo dry
  def removeDuplicates(groups, toremove)
    groups.reduce([]) do |newgroups, group|
      found = false
      toremove.each do |othergroup|
        found ||= othergroup.hands == group.hands
      end
      newgroups << group unless found
      newgroups 
    end
  end

  def groupHands(hands, type)
    prevStaged = false
    groupIndex = -1 
    groups = []

    hands.each do |hand|
      all = @rangeManager.allSet?(hand.to_sym, type)
      any = @rangeManager.anySet?(hand.to_sym, type)
      if all && prevStaged
        groups[groupIndex].hands << hand
      elsif all && !prevStaged
        groups << HandGroup.new([hand], type)
        groupIndex += 1
        prevStaged = true
      elsif any
        singleCombos = @rangeManager.getSetCombos(hand.to_sym, type)
        singles = singleCombos.map do |combo|
          hand.to_s + combo.to_s
        end
        groups << HandGroup.new(singles)
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
