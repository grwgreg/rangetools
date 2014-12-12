require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../hand_groups.rb'
require '../range_manager.rb'


describe 'Hand Groups' do
  before(:each) do
    @rangeManager = RangeTools::RangeManager.new
    @rangeManager.populateRange('Q9-4,Q2sc,Q2cc,Q2sh,QJss,QJcc,QJdd,QJhh')
    @col = "QJ QT Q9 Q8 Q7 Q6 Q5 Q4 Q3 Q2".split(' ')
    @hg = RangeTools::HandGroups.new(@col, @rangeManager)
  end

  it 'has group hands method' do
    expected = [["QJcc", "QJdd", "QJhh", "QJss"], ["Q9", "Q8", "Q7", "Q6", "Q5", "Q4"], ["Q2cc", "Q2sc", "Q2sh"]]

    @hg.groupHands(@col, :all).should == expected
  end

  it 'groups suited hands' do
    expected = [["QJ"], ["Q9", "Q8", "Q7", "Q6", "Q5", "Q4"]]
    @hg.groupHands(@col, :suits).should == expected
  end

  it 'groups offsuited hands' do
    expected = [["Q9", "Q8", "Q7", "Q6", "Q5", "Q4"]]
    @hg.groupHands(@col, :offsuits).should == expected
  end

end
