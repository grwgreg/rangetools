module RangeParser

  def parseRange(rangeString)
    tagBuckets = {
      suited: [],
      offsuited: [],
      both: [],
      single: {}
    }
    expandRangeTags(rangeString, tagBuckets)
  end

  def expandRangeTags(rangeString, tagBuckets)
    rangeTags = rangeString.split(',')
    rangeTags.each do |rangeTag|
      rangeTag.strip!
      tagType = getTagType(rangeTag)
      if tagType.to_s.index('spanner').nil?
        tags = [rangeTag]
      else
        tags = expandRangeTag(rangeTag, tagType)
      end
      tagBuckets = addToTagBucket(tags, tagType, tagBuckets)
    end
    tagBuckets
  end

  def addToTagBucket(tags, tagType, tagBuckets)
    bucket = bucketType(tagType)
    if bucket == :single
      tag = tags[0]
      tagBuckets = addSingle(tag, tagBuckets)
    else
      tags.each do |tag|
        tagBuckets[bucket] << tag.slice(0,2).to_sym
      end
    end
    tagBuckets
  end

  def addSingle(tag, tagBuckets)
    hand = tag.slice(0,2).to_sym
    suit = tag.slice(2,4).to_sym
    tagBuckets[:single][hand] ||= []
    tagBuckets[:single][hand] << suit
    tagBuckets
  end

  def bucketType(tagType)
    types = {
      suited: [:suitspanner, :suit],
      offsuited: [:offsuitspanner, :offsuit],
      both: [:spanner, :pairspanner, :both, :pair],
      single: [:single]
    }

    bucketType = nil
    types.each_pair do |bucket,tagTypes|
      bucketType = bucket if tagTypes.include?(tagType)
    end
    bucketType
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

  def getTagType(rangeTag)
    #order matters here! todo fix it
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
      found = type if rangeTag =~ pattern
    end
    raise 'bad tag in rangestring' if found.nil?
    found
  end
end
