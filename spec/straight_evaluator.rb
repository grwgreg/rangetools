require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../straight_evaluator.rb'


describe 'Straight Evaluator' do

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
    RangeTools::StraightEvaluator.evalStraight(hand, board)[:fullHand].should == :straight

    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :'2', rank: 2},
      {suit: :s, tag: :"3", rank: 3}
      ]
    hand = [
      {suit: :c, tag: :'5', rank: 5},
      {suit: :h, tag: :'9', rank: 9},
      ]
    RangeTools::StraightEvaluator.evalStraight(hand, board)[:fullHand].should == :gutshot

    board = [
      {suit: :c, tag: :J, rank: 11},
      {suit: :h, tag: :T, rank: 10},
      {suit: :s, tag: :"3", rank: 3}
      ]
    hand = [
      {suit: :c, tag: :Q, rank: 12},
      {suit: :h, tag: :K, rank: 13},
      ]
    RangeTools::StraightEvaluator.evalStraight(hand, board)[:fullHand].should == :oesd

    board = [
      {suit: :c, tag: :J, rank: 11},
      {suit: :h, tag: :T, rank: 10},
      {suit: :s, tag: :Q, rank: 12}
      ]
    hand = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :'8', rank: 8},
      ]
    RangeTools::StraightEvaluator.evalStraight(hand, board)[:fullHand].should == :doublegut

    board = [
      {suit: :c, tag: :J, rank: 11},
      {suit: :h, tag: :T, rank: 10},
      {suit: :s, tag: :Q, rank: 12}
      ]
    hand = [
      {suit: :c, tag: :'2', rank: 2},
      {suit: :h, tag: :'7', rank: 7},
      ]
    RangeTools::StraightEvaluator.evalStraight(hand, board)[:fullHand].should == nil
  end

end
