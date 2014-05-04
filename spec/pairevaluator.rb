require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../pairevaluator.rb'


describe 'pairevaluator' do
  before(:each) do
    @board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :J, rank: 11},
      {suit: :s, tag: :"3", rank: 3}
      ]
    hand = [{suit: :h, tag: :T, rank: 11},
    {suit: :h, tag: :"3", rank: 3}
    ]
    @pairEvaluator = PairEvaluator.new(hand, @board)
  end
  it 'has build pair bucket method called on init' do
    pairBuckets = @pairEvaluator.pairBuckets
    pairBuckets[:highs].should include(:T, :A, :J)
    pairBuckets[:pairs].should include(:"3")
    pairBuckets[:trips].empty?.should be_true


    hand = [{suit: :s, tag: :J, rank: 11},
    {suit: :c, tag: :J, rank: 3}
    ]
    pairBuckets = @pairEvaluator.buildPairBuckets(hand, @board)
    pairBuckets[:highs].should include(:A, :"3")
    pairBuckets[:pairs].empty?.should be_true
    pairBuckets[:quads].empty?.should be_true
    pairBuckets[:trips].should include(:J)

    board = [
      {suit: :c, tag: :K, rank: 14},#rank and suits are stripped right away
      {suit: :h, tag: :K, rank: 11},
      {suit: :s, tag: :T, rank: 3},
      {suit: :s, tag: :J, rank: 3}
      ]
    hand = [{suit: :s, tag: :K, rank: 11},
    {suit: :c, tag: :K, rank: 3}
    ]
    pairBuckets = @pairEvaluator.buildPairBuckets(hand, board)
    pairBuckets[:pairs].empty?.should be_true
    pairBuckets[:trips].empty?.should be_true
    pairBuckets[:quads].should include(:K)
    pairBuckets[:highs].should include(:T, :J)

    hand = [{suit: :s, tag: :T, rank: 11},
    {suit: :c, tag: :J, rank: 3}
    ]
    pairBuckets = @pairEvaluator.buildPairBuckets(hand, board)
    pairBuckets[:pairs].should include(:K, :J, :T)
    pairBuckets[:trips].empty?.should be_true
    pairBuckets[:quads].empty?.should be_true
  end
  it 'has replacepairs with numbers method' do
    pairBuckets = {#impossible hand but method only replaces tags with numbers
      quads: [:A],
      trips: [:'4'],
      pairs: [:K, :J],
      highs: [:'3', :'9'],
    }
    @pairEvaluator.pairBuckets = pairBuckets
    @pairEvaluator.replaceTagsWithNumbers
    numberBuckets = @pairEvaluator.pairBuckets
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
    @pairEvaluator.pairBuckets = pairBuckets
    @pairEvaluator.fixHighCardEdgeCases
    fixedBuckets = @pairEvaluator.pairBuckets
    fixedBuckets[:highs].should include(:K, :J, :'3', :'9', :'4')

    pairBuckets = {
      quads: [],
      trips: [],
      pairs: [3, 4, 9],
      highs: [5, 7],
    }
    @pairEvaluator.pairBuckets = pairBuckets
    @pairEvaluator.fixHighCardEdgeCases
    fixedBuckets = @pairEvaluator.pairBuckets
    fixedBuckets[:pairs].length.should == 2
    fixedBuckets[:highs].should include(3)
  end

  it 'has evaluate quads method' do
    pairBuckets = {
      quads: [5],
      trips: [],
      pairs: [3],
      highs: [4, 11, 10]
    }
    @pairEvaluator.pairBuckets = pairBuckets
    @pairEvaluator.madePairHands[:quads].should == 0
    @pairEvaluator.done.should == false
    @pairEvaluator.evalQuads
    @pairEvaluator.madePairHands[:quads].should == 1
    @pairEvaluator.done.should == true
  end 
  it 'has evaluate fullhouse method' do
    pairBuckets = {
      quads: [],
      trips: [11],
      pairs: [3],
      highs: []
    }
    @pairEvaluator.pairBuckets = pairBuckets
    @pairEvaluator.madePairHands[:full_house].should == 0
    @pairEvaluator.done.should == false
    @pairEvaluator.evalFullHouse
    @pairEvaluator.madePairHands[:full_house].should == 1
    @pairEvaluator.done.should == true
  end 
  it 'has eval trips method' do
    pairBuckets = {
      quads: [],
      trips: [12],
      pairs: [],
      highs: [4,2]
    }
    @pairEvaluator.pairBuckets = pairBuckets
    @pairEvaluator.madePairHands[:trips].should == 0
    @pairEvaluator.done.should == false
    @pairEvaluator.evalTrips
    @pairEvaluator.madePairHands[:trips].should == 1
    @pairEvaluator.done.should == true
  end 
  it 'has eval twopair method' do
    pairBuckets = {
      quads: [],
      trips: [],
      pairs: [4,5],
      highs: [9]
    }
    @pairEvaluator.pairBuckets = pairBuckets
    @pairEvaluator.madePairHands[:two_pair].should == 0
    @pairEvaluator.done.should == false
    @pairEvaluator.evalTwoPair
    @pairEvaluator.madePairHands[:two_pair].should == 1
    @pairEvaluator.done.should == true

    pairBuckets = {
      quads: [],
      trips: [],
      pairs: [4],
      highs: [9]
    }
    @pairEvaluator.madePairHands[:two_pair] = 0
    @pairEvaluator.pairBuckets = pairBuckets
    @pairEvaluator.evalTwoPair
    @pairEvaluator.madePairHands[:two_pair].should == 0
  end 
  it 'has eval pair method' do
    pairBuckets = {
      quads: [],
      trips: [],
      pairs: [9],
      highs: [4,2,8]
    }
    @pairEvaluator.pairBuckets = pairBuckets
    @pairEvaluator.madePairHands[:pair].should == 0
    @pairEvaluator.done.should == false
    @pairEvaluator.evalPair
    @pairEvaluator.madePairHands[:pair].should == 1
    @pairEvaluator.done.should == true
  end 
end
