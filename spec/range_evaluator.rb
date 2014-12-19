require 'rubygems'
require 'bundler/setup'
require 'rspec'
require './hand_evaluator.rb'
require './range_evaluator.rb'
require './range_manager.rb'
require 'ostruct'


describe 'Range Evaluator' do
  before(:each) do
    board = [
      {suit: :h, tag: :A, rank: 14},
      {suit: :d, tag: :A, rank: 14},
      {suit: :h, tag: :"3", rank: 3}
    ]
    @rangeEvaluator = RangeTools::RangeEvaluator.new(board)

    range = "AKsc,QT-9,33";
    @rangeManager = rangeManager = RangeTools::RangeManager.new
    rangeManager.populateRange(range)
    @range = rangeManager.range
  end

  it 'builds card hashes from string of board cards' do
    board = @rangeEvaluator.buildBoard('Ks,9h,2c,Ts')
    board.should == [
      {:tag=>:K, :rank=>13, :suit=>:s},
      {:tag=>:"9", :rank=>9, :suit=>:h},
      {:tag=>:"2", :rank=>2, :suit=>:c},
      {:tag=>:T, :rank=>10, :suit=>:s}
    ]

  end

  it 'builds board when instantiated with string' do
        board = 'Ks,9h,2c,Ts'
    rangeEvaluator = RangeTools::RangeEvaluator.new(board)

    rangeEvaluator.board.should == [
      {:tag=>:K, :rank=>13, :suit=>:s},
      {:tag=>:"9", :rank=>9, :suit=>:h},
      {:tag=>:"2", :rank=>2, :suit=>:c},
      {:tag=>:T, :rank=>10, :suit=>:s}
    ]
  end

  it 'has allTwoCardHashes method which gets every possible hand from range for the evalHand method' do
    range = "AKsc,QT-9";
    rangeManager = RangeTools::RangeManager.new
    rangeManager.populateRange(range)
    hashes = @rangeEvaluator.allTwoCardHashes(rangeManager.range)
    hashes.length.should == 33
    #this order could possibly change but should be 33 combos with at least one matching this
    hashes[2].should == [
      {:suit=>:c, :rank=>12, :tag=>:Q},
      {:suit=>:h, :rank=>9, :tag=>:"9"}
    ]
  end

  it 'has evaluateRange method' do
    @rangeEvaluator.evaluateRange(@range)
    @rangeEvaluator.madeHands[:full_house].should ==
    ["33cd", "33cs", "33dc", "33ds", "33sc", "33sd"]
  end


  it 'statistics method loops through and builds hash with percents of hand type' do
    @rangeEvaluator.evaluateRange(@range)
    stats = @rangeEvaluator.statistics
    stats[:full_house].should == 0.15384615384615385
  end

  it 'range report is hash with percent of range and specific hands for type' do
    @rangeEvaluator.evaluateRange(@range)
    report = @rangeEvaluator.rangeReport(@rangeManager)
    report[:pair_plus_draw].should ==
    {:percent=>0.05128205128205128,
      :percent_of_group=>0,
      :hands=>["Q9hh", "QThh"],
      :handRange=>"QThh,Q9hh"
    }

    report[:full_house].should ==
    {:percent=>0.15384615384615385,
      :percent_of_group=>1.0,
      :hands=>["33cd", "33cs", "33dc", "33ds", "33sc", "33sd"],
      :handRange=>"33cd,33cs,33dc,33ds,33sc,33sd"
    }
  end

end
