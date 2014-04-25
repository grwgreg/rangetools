class RangeParser
   attr_accessor :tagBuckets

  def initialize(range)
    @range = range
    @tagBuckets = {
      suited: [],
      offsuited: [],
      both: [],
      single: {}
    }
  end

=begin
  def parseRange(rangeString)
    expandRangeTags(rangeString)
    populateRange(@tagBuckets)
  end
=end

  def expandRangeTags(rangeString)
    tags = []
    rangeTags = rangeString.split(',')
    rangeTags.each do |rangeTag|
      rangeTag.strip!
      tagType = getTagType(rangeTag)
      raise 'bad tag in rangestring' if tagType.nil?
      if tagType.to_s.index('spanner').nil?
        tags = [rangeTag]
      else
        tags = expandRangeTag(rangeTag, tagType)
      end
      #maybe put in another method, have this return the type and also tags
      #or take the get tag type out and put in antoher method <--this
      addToTagBucket(tags, tagType)
    end
  end

  def addToTagBucket(tags, tagType)
    bucket = bucketType(tagType)
    if bucket == :single
      tag = tags[0]
      addSingle(tag)
    else
      tags.each do |tag|
        @tagBuckets[bucket] << tag.slice(0,2)
      end
    end
  end

  def addSingle(tag)
    hand = tag.slice(0,2)
    suit = tag.slice(2,4)
    tagBuckets[:single][hand] ||= []
    tagBuckets[:single][hand] << suit
  end

  def bucketType(tagType)
    types = {
      suited: [:suitspanner, :suit],
      offsuited: [:offsuitspanner, :offsuit],
      both: [:spanner, :pairspanner, :both, :pair],
      single: [:single]
    }

    if types[:suited].include?(tagType)
      bucket = :suited
    elsif types[:offsuited].include?(tagType)
      bucket = :offsuited
    elsif types[:both].include?(tagType)
      bucket = :both
    elsif types[:single].include?(tagType)
      bucket = :single
    end
    bucket
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
      if rangeTag =~ pattern then found = type end
    end
    found
  end
end
