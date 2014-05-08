require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../handevaluator.rb'


describe 'Range Tools' do
  before(:each) do
    @handEvaluator = HandEvaluator.new
    hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :c, tag: :'A', rank: 14}
      ]
    @handEvaluator.twoCardHand = hand
    @handEvaluator.board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :J, rank: 11},
      {suit: :s, tag: :"3", rank: 3}
      ]
  end

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

  it 'has straight diffs method' do
    diffs = @handEvaluator.straightDiffs([4,5,8,11,14])
    diffs.should == [1,3,3,3]
  end

  it 'has straight matcher method to determine straight draw type' do
    @handEvaluator.straightMatch([1,1,1,1,2]).should == :straight 
    @handEvaluator.straightMatch([1,2,1,1,2]).should == :doublegut 
    @handEvaluator.straightMatch([1,2,2,1,4]).should == nil 
    @handEvaluator.straightMatch([1,2,2,1,1]).should == :gutshot 
    @handEvaluator.straightMatch([3,1,1,1,2]).should == :oesd 
  end

  it 'has evalStraights method' do
    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :'2', rank: 2},
      {suit: :s, tag: :"3", rank: 3}
      ]
    hand = [
      {suit: :c, tag: :'5', rank: 5},
      {suit: :h, tag: :'4', rank: 4},
      ]
    @handEvaluator.evalStraight(hand, board).should == :straight

    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :'2', rank: 2},
      {suit: :s, tag: :"3", rank: 3}
      ]
    hand = [
      {suit: :c, tag: :'5', rank: 5},
      {suit: :h, tag: :'9', rank: 9},
      ]
    @handEvaluator.evalStraight(hand, board).should == :gutshot

    board = [
      {suit: :c, tag: :J, rank: 11},
      {suit: :h, tag: :T, rank: 10},
      {suit: :s, tag: :"3", rank: 3}
      ]
    hand = [
      {suit: :c, tag: :Q, rank: 12},
      {suit: :h, tag: :K, rank: 13},
      ]
    @handEvaluator.evalStraight(hand, board).should == :oesd

    board = [
      {suit: :c, tag: :J, rank: 11},
      {suit: :h, tag: :T, rank: 10},
      {suit: :s, tag: :Q, rank: 12}
      ]
    hand = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :'8', rank: 8},
      ]
    @handEvaluator.evalStraight(hand, board).should == :doublegut

    board = [
      {suit: :c, tag: :J, rank: 11},
      {suit: :h, tag: :T, rank: 10},
      {suit: :s, tag: :Q, rank: 12}
      ]
    hand = [
      {suit: :c, tag: :'2', rank: 2},
      {suit: :h, tag: :'7', rank: 7},
      ]
    @handEvaluator.evalStraight(hand, board).should == nil
  end

  it 'has find sub array for finding straights' do
    hay = [4,5,2,44,3,0,5]
    needle = [44,3,0,5]
    @handEvaluator.findSubArray(hay, needle).should == true
    hay = [4,5,2,44,3,0,5]
    needle = [4,5,2,44,3,0,5]
    @handEvaluator.findSubArray(hay, needle).should == true
    hay = [4,5,2,44,3,0,5]
    needle = [4,5,2,44,3,0,5,3]
    @handEvaluator.findSubArray(hay, needle).should == false
    hay = [4,3,0,5]
    needle = [9]
    @handEvaluator.findSubArray(hay, needle).should == false
  end

  it 'has build suit buckets method' do
    board = [:c, :s, :c, :d, :s]
    buckets = @handEvaluator.buildSuitBuckets(board)
    buckets[:c].should == 2
    buckets[:d].should == 1
    buckets[:s].should == 2
    buckets[:h].should == nil
  end

  it 'has build hand tag method for array of found hands' do 
    hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :c, tag: :'A', rank: 14}
      ]
    @handEvaluator.twoCardHand = hand
    @handEvaluator.buildHandTag(hand).should == 'AJch'
  end

end
