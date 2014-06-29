require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../handevaluator.rb'
require '../rangeevaluator.rb'
require 'ostruct'


describe 'Range Evaluator' do
  before(:each) do
    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :J, rank: 11},
      {suit: :s, tag: :"3", rank: 3}
    ]
    @rangeEvaluator = RangeEvaluator.new(board)
  end

  it 'has evaluateRange method' do
    range = {
      AA: {
        cc: true,
        cd: false,
        cs: false
      },
      JT: {
        cd: false,
        cs: false,
        dd: true
      },
      KT: {
        cd: false,
        cs: false,
        dd: false
      },
      :'93' => {
        cd: false,
        hc: true,
        cs: false
      }
    }
  
  @rangeEvaluator.evaluateRange(range)
  puts @rangeEvaluator.madeHands
  end

end
