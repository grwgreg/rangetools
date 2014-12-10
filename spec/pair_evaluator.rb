require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../pair_evaluator.rb'


describe 'pairevaluator' do
  before(:each) do
  end
  it 'has build pair bucket method called on init' do

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
puts 'xxxxxxxxx'
puts x
puts 'xxxxxxxxx'
  end
end
