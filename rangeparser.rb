class RangeParser

  def initialize(range)
    @range = range
  end

  def expandRangeTag(rangeTag, tagType)
    span = expandSpanner(rangeTag)
    expandedTags = nil
    if tagType == :pairspanner
      expandedTags = span.collect {|card| card + card}
    else
      suitTag = suitedType(tagType)
      expandedTags = span.collect do |rightCard|
        rangeTag[0] + rightCard + suitTag
      end
    end
    expandedTags
  end

  def suitedType(tagType)
      case tagType
      when :suitspanner then 's'
      when :offsuitspanner then 'o'
      when :spanner then ''
      end
  end

  def expandSpanner(rangeTag)
    ranks = 'AKQJT98765432'
    startCard = ranks.index(rangeTag[1])
    endCard = ranks.index(rangeTag[3])
    span = ranks.slice(startCard, endCard - startCard + 1)
    span.split('')
  end

  def tagType(rangeTag)
    tagTypes = {
      spanner: /^[A-Z\d]+-[A-Z\d]+$/,
      suitspanner: /^[A-Z\d]+-[A-Z\d]s+$/,
      offsuitspanner: /^[A-Z\d]+-[A-Z\d]o+$/,
      pairspanner: /^([A-Z\d])\1-([A-Z\d])\2$/,
      offsuit: /^[A-Z\d][A-Z\d]o$/,
      suit: /^[A-Z\d][A-Z\d]s$/,
      both: /^[A-Z\d][A-Z\d]$/,
      single: /^[A-Z\d][A-Z\d][cdhs][cdhs]$/,
      pair: /^([A-Z\d])\1$/
    }
    found = nil
    tagTypes.each_pair do |type, pattern|
      if rangeTag =~ pattern then found = type end
    end
    found
  end
end
