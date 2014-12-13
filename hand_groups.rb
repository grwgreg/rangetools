require './hand_group.rb'

module RangeTools
class HandGroups
  attr_accessor :rangeManager
  attr_accessor :groups

  def initialize(hands, rangeManager)
    @rangeManager = rangeManager
    @offsuits = groupHands(hands, :offsuits)
    @suits = groupHands(hands, :suits)
    @all = groupHands(hands, :all)

#in js program i first get the "inboth" of offsuits and suits then remove them from suits and offuits
#i think both offsuits and suits can contain singles i honestly have no clue

#TODO: get rid of the :all grouphands pass, you should be grabbing single groups alogn with full
#then match the js, the 'ALL' group should be made by finding matches in suits and offsuits
#then remove the all group from both suits and offsuits
#you have to CREATE a new array of handGroups for all
#ie find matched array then newgroups << HandGroup.new(matchedgroup.hands, :all) or whatever

@offsuits = removeDuplicates(@offsuits, @all)
@suits = removeDuplicates(@suits, @all)
@groups = @all + @offsuits + @all

  end

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
      elsif any && type == :all#problem could be here questiont o ask is should i just do a suits pass and offsuits pass getting singles
#or should i do a sep pass for all
        singleCombos = @rangeManager.getSetCombos(hand.to_sym, type) #problem could be here, when called with all will get duplicates
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

  def to_s
    
  end
end
end
