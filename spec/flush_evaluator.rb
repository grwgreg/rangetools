require 'rubygems'
require 'bundler/setup'
require 'rspec'
require './flush_evaluator.rb'


describe 'Flush Evaluator' do
  before(:each) do
    @hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :c, tag: :'A', rank: 14}
    ]
    @board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :J, rank: 11},
      {suit: :s, tag: :"3", rank: 3}
    ]
    @flushEvaluator = RangeTools::FlushEvaluator
  end

  it 'has class method evalFlush' do
    @flushEvaluator.evalFlush(@hand, @board)[:fullHand].should == nil
    @hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :h, tag: :'A', rank: 14}
    ]
    @board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :J, rank: 11},
      {suit: :h, tag: :"3", rank: 3}
    ]
    @flushEvaluator.evalFlush(@hand, @board)[:fullHand].should == :flush_draw 
    @hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :h, tag: :'A', rank: 14}
    ]
    @board = [
      {suit: :h, tag: :A, rank: 14},
      {suit: :h, tag: :J, rank: 11},
      {suit: :h, tag: :"3", rank: 3}
    ]
    @flushEvaluator.evalFlush(@hand, @board)[:fullHand].should == :flush 
  end

  it 'returns flush on board if on board' do
    @hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :h, tag: :'A', rank: 14}
    ]
    @board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :c, tag: :A, rank: 12},
      {suit: :c, tag: :A, rank: 13},
      {suit: :c, tag: :J, rank: 11},
      {suit: :c, tag: :"3", rank: 3}
    ]
    @flushEvaluator.evalFlush(@hand, @board)[:board].should == :flush
    @hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :h, tag: :'A', rank: 14}
    ]
    @board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :c, tag: :A, rank: 12},
      {suit: :c, tag: :A, rank: 13},
      {suit: :c, tag: :J, rank: 11},
      {suit: :s, tag: :"3", rank: 3}
    ]
    @flushEvaluator.evalFlush(@hand, @board)[:board].should == :flush_draw
  end
end
