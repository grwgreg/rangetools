require 'rubygems'
require 'bundler/setup'
require 'rspec'
require './pair_evaluator.rb'


describe 'pairevaluator' do
  before(:each) do
  end
  it 'correctly identifies no pair' do
    board = [
      {suit: :c, tag: :T, rank: 10},
      {suit: :h, tag: :K, rank: 13},
      {suit: :s, tag: :"3", rank: 3}
    ]
    hand = [
      {suit: :h, tag: :J, rank: 11},
      {suit: :h, tag: :A, rank: 14}
    ]
    x = RangeTools::PairEvaluator.evalPairHands(hand, board)
    x[:ace_high].should == true
    x[:one_over_card].should == true
    x.keys.should_not include :pair
  end
  it 'correctly identifies pair' do
    board = [
      {suit: :c, tag: :T, rank: 10},
      {suit: :h, tag: :K, rank: 13},
      {suit: :s, tag: :"3", rank: 3}
    ]
    hand = [
      {suit: :h, tag: :J, rank: 11},
      {suit: :h, tag: :T, rank: 10}
    ]
    x = RangeTools::PairEvaluator.evalPairHands(hand, board)
    x[:pair].should == true
  end
  it 'correctly identifies trips' do
    board = [
      {suit: :c, tag: :T, rank: 10},
      {suit: :h, tag: :K, rank: 13},
      {suit: :s, tag: :"3", rank: 3}
    ]
    hand = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :h, tag: :T, rank: 10}
    ]
    x = RangeTools::PairEvaluator.evalPairHands(hand, board)
    x[:trips].should == true
  end
  it 'correctly identifies two pair' do
    board = [
      {suit: :c, tag: :T, rank: 10},
      {suit: :h, tag: :K, rank: 13},
      {suit: :s, tag: :"3", rank: 3}
    ]
    hand = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :h, tag: :"3", rank: 3}
    ]
    x = RangeTools::PairEvaluator.evalPairHands(hand, board)
    x[:two_pair].should == true
  end
  it 'correctly identifies fullhouse' do
    board = [
      {suit: :c, tag: :T, rank: 10},
      {suit: :d, tag: :"3", rank: 3},
      {suit: :s, tag: :"3", rank: 3}
    ]
    hand = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :s, tag: :T, rank: 10}
    ]
    x = RangeTools::PairEvaluator.evalPairHands(hand, board)
    x[:full_house].should == true
  end
end
