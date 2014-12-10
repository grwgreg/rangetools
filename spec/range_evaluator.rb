require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../hand_evaluator.rb'
require '../range_evaluator.rb'
require 'ostruct'


describe 'Range Evaluator' do
  before(:each) do
    board = [
      {suit: :h, tag: :A, rank: 14},
      {suit: :h, tag: :J, rank: 11},
      {suit: :h, tag: :"3", rank: 3}
    ]
    @rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    @range = {
      AA: {
        cc: true,
      },
      JT: {
        cd: true,
        cs: true,
        dd: true,
      },
      KT: {
        cd: true,
        cs: true,
        dd: true
      },
      :'93' => {
        cd: false,
        hc: true,
        cs: false,
        ss: true
      },
      :'45' => {
        hh: true
      }
    }
  end

  it 'has evaluateRange method' do
    @rangeEvaluator.evaluateRange(@range)
  end

  its 'statistics method loops through and builds hash with percents of hand type' do
    @rangeEvaluator.evaluateRange(@range)
    @rangeEvaluator.statistics
  end

  its 'range report is hash to turn to json and serve' do
    @rangeEvaluator.evaluateRange(@range)
#    puts @rangeEvaluator.rangeReport
    report = @rangeEvaluator.rangeReport
  #there are 10 total hands in range so 3 made hands is .3 etc
    report[:trips][:percent].should == 0.1
    report[:trips][:hands].should == ['AAcc'] 

    report[:high_pair].should == {:percent=>0.3, :hands=>["JTcd", "JTcs", "JTdd"]}
    
  end

  it 'builds card hashes from string of board cards' do
    
    puts @rangeEvaluator.buildBoard('Ks,9h,2c')
  end

end
