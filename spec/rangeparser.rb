require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../rangeparser.rb'

class RangeManager
  include RangeParser
end

rangeManager = RangeManager.new

describe 'RangeParser module' do
  it 'parses range returns tag buckets' do
    tagBuckets = rangeManager.parseRange('KJ, QTs,98cc')
    tagBuckets[:suited].should == [:QT]
    tagBuckets[:offsuited].should == []
    tagBuckets[:both].should == [:KJ]
    tagBuckets[:single].should ==  {:'98' => [:cc]}

    tagBuckets = rangeManager.parseRange('AA-JJ, 87-5')
    tagBuckets[:suited].should == []
    tagBuckets[:offsuited].should == []
    tagBuckets[:both].should == [:AA, :KK, :QQ, :JJ, :'87', :'86', :'85']
    tagBuckets[:single].should ==  {}
  end
end
