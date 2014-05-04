require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../handevaluator.rb'


describe 'Range Tools' do
  before(:each) do
    @handEvaluator = HandEvaluator.new
    @handEvaluator.board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :J, rank: 11},
      {suit: :s, tag: :"3", rank: 3}
      ]
  end
=begin #moved to pairBuckets class
  it 'has build pair bucket method' do
    #@rangeManager.range[:AK][:cc].should == false
    hand = [{suit: :h, tag: :T, rank: 11},
    {suit: :h, tag: :"3", rank: 3}
    ]
    pairBuckets = @handEvaluator.buildPairBuckets(hand)
    pairBuckets[:highs].should include(:T, :A, :J)
    pairBuckets[:pairs].should include(:"3")
    pairBuckets[:trips].empty?.should be_true


    hand = [{suit: :s, tag: :J, rank: 11},
    {suit: :c, tag: :J, rank: 3}
    ]
    pairBuckets = @handEvaluator.buildPairBuckets(hand)
    pairBuckets[:highs].should include(:A, :"3")
    pairBuckets[:pairs].empty?.should be_true
    pairBuckets[:quads].empty?.should be_true
    pairBuckets[:trips].should include(:J)

    @handEvaluator.board = [
      {suit: :c, tag: :K, rank: 14},#rank and suits are stripped right away
      {suit: :h, tag: :K, rank: 11},
      {suit: :s, tag: :T, rank: 3},
      {suit: :s, tag: :J, rank: 3}
      ]
    hand = [{suit: :s, tag: :K, rank: 11},
    {suit: :c, tag: :K, rank: 3}
    ]
    pairBuckets = @handEvaluator.buildPairBuckets(hand)
    pairBuckets[:pairs].empty?.should be_true
    pairBuckets[:trips].empty?.should be_true
    pairBuckets[:quads].should include(:K)
    pairBuckets[:highs].should include(:T, :J)

    hand = [{suit: :s, tag: :T, rank: 11},
    {suit: :c, tag: :J, rank: 3}
    ]
    pairBuckets = @handEvaluator.buildPairBuckets(hand)
    pairBuckets[:pairs].should include(:K, :J, :T)
    pairBuckets[:trips].empty?.should be_true
    pairBuckets[:quads].empty?.should be_true
  end
=end

  it 'rankNumber method to convert symbol to number' do
    @handEvaluator.rankNumber(:J).should == 11
    @handEvaluator.rankNumber(:'4').should == 4
  end

  it 'buildcardhashes method returns array of 2el arrays of hashes' do
    hands = @handEvaluator.buildCardHashes(:'7', :'2', {cc: true, dc: true, hs: true})
    hands[0][0].should == {suit: :c, rank: 7, tag: :'7'}
    hands[0][1].should == {suit: :c, rank: 2, tag: :'2'}

    hands[2][0].should == {suit: :h, rank: 7, tag: :'7'}
    hands[2][1].should == {suit: :s, rank: 2, tag: :'2'}
  end

  it 'allTwoCardHashes returns array of all 2 card hands in range' do
    range = {
    :AA => {:cs => true, :dc => false, :hs => true},
    :KJ => {:ss => true, :hh => false},
    :'77' => {:ds => true, :sd => true}
    }
    allHands = @handEvaluator.allTwoCardHashes(range)
=begin
  puts '---allhands-'
  puts allHands[2]
  puts '---'

  allHands.each do |twoCard|
    puts '---twocard-'
    puts twoCard 
    puts '---'
  end
=end
    allHands.length.should == 5
    allHands.should include([{:suit=>:d, :rank=>7, :tag=>:"7"}, {:suit=>:s, :rank=>7, :tag=>:"7"}])
  end

=begin
  it 'has replacepairs with numbers method' do
    pairBuckets = {#impossible hand but method only replaces tags with numbers
      quads: [:A],
      trips: [:'4'],
      pairs: [:K, :J],
      highs: [:'3', :'9'],
    }
    numberBuckets = @handEvaluator.replaceTagsWithNumbers(pairBuckets)
    numberBuckets[:quads].should == [14]
    numberBuckets[:trips].should == [4]
    numberBuckets[:pairs].should include(13,11)
    numberBuckets[:highs].should include(3,9)
  end


  it 'has fixhighcard edgecases method' do
    #so AAAAKK beats AAAA2J and AAKKQQ beats AAKKJ2
    pairBuckets = {
      quads: [:A],
      trips: [:'4'],
      pairs: [:K, :J],
      highs: [:'3', :'9'],
    }
    fixedBuckets = @handEvaluator.fixHighCardEdgeCases(pairBuckets)
    fixedBuckets[:highs].should include(:K, :J, :'3', :'9', :'4')

    pairBuckets = {
      quads: [],
      trips: [],
      pairs: [3, 4, 9],
      highs: [5, 7],
    }
    fixedBuckets = @handEvaluator.fixHighCardEdgeCases(pairBuckets)
    fixedBuckets[:pairs].length.should == 2
    fixedBuckets[:highs].should include(3)
  end
=end
end
