require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../range_manager.rb'
require '../range_evaluator.rb'
require '../hand_evaluator.rb'
require '../pair_evaluator.rb'


describe 'Range Tools' do
  before(:each) do
    @rangeManager = RangeTools::RangeManager.new

    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :s, tag: :J, rank: 11},
      {suit: :s, tag: :"3", rank: 3}
    ]
    @rangeEvaluator = RangeTools::RangeEvaluator.new(board)
  end
  it 'rangeparser parses raneg and populates range object' do
    @rangeManager.range[:AK][:cc].should == false
    @rangeManager.range[:KJ][:cc].should == false
    @rangeManager.populateRange('AK, KJs, 99, QJ-6, T4-2s, 53o, 87-3o, 66-22')
    @rangeManager.range[:AK][:cc].should == true
    @rangeManager.range[:KJ][:cc].should == true
    @rangeManager.range[:KJ][:cs].should == false
    @rangeManager.range[:'99'][:cs].should == true
    @rangeManager.range[:QJ][:cs].should == true
    @rangeManager.range[:Q8][:ch].should == true
    @rangeManager.range[:Q6][:ds].should == true
    @rangeManager.range[:T4][:dd].should == true
    @rangeManager.range[:T3][:hh].should == true
    @rangeManager.range[:T3][:hs].should == false
    @rangeManager.range[:T2][:ss].should == true
    @rangeManager.range[:'53'][:ss].should == false
    @rangeManager.range[:'53'][:sc].should == true
    @rangeManager.range[:'87'][:sc].should == true
    @rangeManager.range[:'87'][:ss].should == false
    @rangeManager.range[:'84'][:hh].should == false
    @rangeManager.range[:'84'][:hc].should == true
    @rangeManager.range[:'83'][:hc].should == true
    @rangeManager.range[:'66'][:ch].should == true
    @rangeManager.range[:'44'][:cs].should == true
    @rangeManager.range[:'22'][:ds].should == true
  end
  it 'blalba' do

    @rangeManager.populateRange('AK, KJs, 99, QJ-6, T4-2s, 53o, 87-3o, 66-22')
    @rangeEvaluator.evaluateRange(@rangeManager.range)

   @rangeEvaluator.madeHands[:pocket_pair].should include('99cd')
   @rangeEvaluator.madeHands[:pocket_pair].should_not include('99cc')
  end

  it 'A234 should be a gutshot' do
    rangeManager = RangeTools::RangeManager.new
    board = [
      {suit: :c, tag: :K, rank: 13},
      {suit: :s, tag: :'3', rank: 3},
      {suit: :s, tag: :'2', rank: 2}
    ]
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('A4dd')
    rangeEvaluator.evaluateRange(rangeManager.range)
    rangeEvaluator.madeHands[:gutshot].should include('A4dd')
  end

  it 'AKQJ should be a gutshot' do
    rangeManager = RangeTools::RangeManager.new
    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :s, tag: :K, rank: 13},
      {suit: :s, tag: :Q, rank: 12},
      {suit: :s, tag: :J, rank: 11}
    ]
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('43dd')
    rangeEvaluator.evaluateRange(rangeManager.range)
    rangeEvaluator.madeHands[:gutshot].should include('43dd')
  end

  it 'Removes board cards from range' do
    rangeManager = RangeTools::RangeManager.new
    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :s, tag: :'2', rank: 2},
      {suit: :s, tag: :'3', rank: 3},
      {suit: :c, tag: :'3', rank: 3}
    ]
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('T3')
    rangeEvaluator.evaluateRange(rangeManager.range)
    rangeEvaluator.madeHands[:trips].length.should == 8
  end
  it 'is fun' do
    rangeManager = RangeTools::RangeManager.new
    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :s, tag: :'7', rank: 7},
      {suit: :c, tag: :'3', rank: 3}
    ]
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('AK-T, AA-22, KQ-T, QJ-8, JT-8, T9-7, 98-6, 87-5, 76-5,65ss,65dd')
    rangeEvaluator.evaluateRange(rangeManager.range)
    #rangeEvaluator.madeHands[:trips].length.should == 8
  end
  it 'fullhouses work' do
    rangeManager = RangeTools::RangeManager.new
    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :s, tag: :'7', rank: 7},
      {suit: :c, tag: :'7', rank: 7}
    ]
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('AA')
    rangeEvaluator.evaluateRange(rangeManager.range)
    #rangeEvaluator.madeHands[:trips].length.should == 8
  end
  it 'straight on board' do#doing away with this functionailty for now
    rangeManager = RangeTools::RangeManager.new
    board = [
      {suit: :c, tag: :T, rank: 10},
      {suit: :s, tag: :'8', rank: 8},
      {suit: :c, tag: :'7', rank: 7},
      {suit: :c, tag: :'9', rank: 6},
      {suit: :d, tag: :'6', rank: 9}
    ]
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('AKcs')
    rangeEvaluator.evaluateRange(rangeManager.range)
#    rangeEvaluator.madeHands[:straight_on_board].should include('AKcs') 
  end
  it 'flush draw  on board' do
    rangeManager = RangeTools::RangeManager.new
    board = [
      {suit: :d, tag: :T, rank: 10},
      {suit: :d, tag: :'8', rank: 8},
      {suit: :c, tag: :'2', rank: 2},
      {suit: :d, tag: :K, rank: 13},
      {suit: :d, tag: :'6', rank: 9}
    ]
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('A3cs')
    rangeEvaluator.evaluateRange(rangeManager.range)
    rangeEvaluator.madeHands[:flush_draw_on_board].should include('A3cs') 
  end
  it 'pair plus flushdraw' do
    rangeManager = RangeTools::RangeManager.new
    board = [
      {suit: :c, tag: :T, rank: 10},
      {suit: :c, tag: :'8', rank: 8},
      {suit: :c, tag: :'7', rank: 7},
      {suit: :h, tag: :A, rank: 14},
      {suit: :d, tag: :'2', rank: 2}
    ]
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('A4cs')
    rangeEvaluator.evaluateRange(rangeManager.range)
    rangeEvaluator.madeHands[:pair_plus_flush_draw].should include('A4cs') 

  end
  it 'straight draw on board' do
    rangeManager = RangeTools::RangeManager.new
    board = 'Tc,8s,7c,9c'
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('AKcs')
    rangeEvaluator.evaluateRange(rangeManager.range)
    rangeEvaluator.madeHands[:oesd_on_board].should include('AKcs') 
  end
  it 'not include draws in stats if 5 board cards present' do
    rangeManager = RangeTools::RangeManager.new
    board = [
      {suit: :c, tag: :T, rank: 10},
      {suit: :s, tag: :'8', rank: 8},
      {suit: :c, tag: :'7', rank: 7},
      {suit: :c, tag: :'9', rank: 9},
      {suit: :d, tag: :'2', rank: 2}
    ]
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)
    rangeManager.populateRange('AK-Ts, AA-JJ, KQs, AK-Jo')
    rangeEvaluator.evaluateRange(rangeManager.range)
    x =  rangeEvaluator.rangeReport
puts x.inspect
puts 'dddddddddd'
puts x[:oesd]
puts 'dddddddddd'
  end
end
