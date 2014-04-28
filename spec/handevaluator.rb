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
end
