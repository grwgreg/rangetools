require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../rangeparser.rb'

rangeParser = RangeParser.new(nil)
describe rangeParser do
  it 'has getTagType method detrmine rangestring type' do
    rangeParser.getTagType('AKs').should == :suit
    rangeParser.getTagType('AK').should == :both
    rangeParser.getTagType('AK-2').should == :spanner
    rangeParser.getTagType('AK-4s').should == :suitspanner
    rangeParser.getTagType('AK-4o').should == :offsuitspanner
    rangeParser.getTagType('AKo').should == :offsuit
    rangeParser.getTagType('AA').should == :pair
    rangeParser.getTagType('AAcd').should == :single
    rangeParser.getTagType('AA-44').should == :pairspanner
  end

  it 'has expand range method for spanning cards' do
    rangeParser.expandRangeTag('KJ-4', :spanner)[2].should == 'K9'
    rangeParser.expandRangeTag('KJ-4s', :suitspanner)[2].should == 'K9s'
    rangeParser.expandRangeTag('KJ-4o', :offsuitspanner)[2].should == 'K9o'
    rangeParser.expandRangeTag('KK-2', :pairspanner)[2].should == 'JJ'
  end

  it 'has expand range tags method for taking range string filling tag buckets' do
    rangeParser.expandRangeTags('AK, QJs, 98cc, 97sc, 98ss, 76-3s, Q9-4, 55, 87-2, 99-22, 76-5s, 98-5o, KJcs')
    puts 'strt'
    puts rangeParser.tagBuckets.inspect
    puts 'here'

    expect { rangeParser.expandRangeTags('AK, afs') }.to raise_error
  end

end

