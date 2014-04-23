require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../rangeparser.rb'

rangeParser = RangeParser.new(nil)
describe rangeParser do
  it 'has tagType method detrmine rangestring type' do
    rangeParser.tagType('AKs').should == :suit
    rangeParser.tagType('AK').should == :both
    rangeParser.tagType('AK-2').should == :spanner
    rangeParser.tagType('AK-4s').should == :suitspanner
    rangeParser.tagType('AK-4o').should == :offsuitspanner
    rangeParser.tagType('AKo').should == :offsuit
    rangeParser.tagType('AA').should == :pair
    rangeParser.tagType('AAcd').should == :single
    rangeParser.tagType('AA-44').should == :pairspanner
  end

  it 'has expand range method for spanning cards' do
    puts rangeParser.expandRangeTag('AK-2s', :suitspanner).inspect
    puts rangeParser.expandRangeTag('QT-4o', :offsuitspanner).inspect
    puts rangeParser.expandRangeTag('AA-TT', :pairspanner).inspect

    rangeParser.expandRangeTag('KJ-4', :spanner)[2].should == 'K9'
    rangeParser.expandRangeTag('KJ-4s', :suitspanner)[2].should == 'K9s'
    rangeParser.expandRangeTag('KJ-4o', :offsuitspanner)[2].should == 'K9o'
    rangeParser.expandRangeTag('KK-2', :pairspanner)[2].should == 'JJ'
  end
end

