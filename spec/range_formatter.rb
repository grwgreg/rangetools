require 'rubygems'
require 'bundler/setup'
require 'rspec'
require './range_formatter.rb'
require './range_manager.rb'

rangeManager = RangeTools::RangeManager.new

describe 'RangeFormatter module' do
  before(:each) do
    @rangeManager = RangeTools::RangeManager.new
  end
  it 'range manager parses range string, populates range, and creates new representation of range string' do
    #idea is there are many valid range strings that represent the same range
    #but each range will be formatted by the rangemanager to the same string
    @rangeManager.populateRange('33,Q9-4,Q2sc,AK,AQ,88,99,Q2cc,Q2sh,QJss,QJcc,QJdd,QJhh')
    @rangeManager.formatRange.should == '99-8,33,AK-Q,Q9-4,QJs,Q2cc,Q2sc,Q2sh'

    @rangeManager.resetAll
    @rangeManager.populateRange('KJo,98-3o')
    @rangeManager.formatRange.should == 'KJo,98-3o'
  end
end
