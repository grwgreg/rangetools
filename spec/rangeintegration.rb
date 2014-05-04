require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../rangemanager.rb'
require '../rangeparser.rb'


describe 'Range Tools' do
  before(:each) do
    @rangeManager = RangeManager.new
    @rangeParser = RangeParser.new(@rangeManager)
  end
  it 'rangeparser parses raneg and populates range object' do
    @rangeManager.range[:AK][:cc].should == false
    @rangeManager.range[:KJ][:cc].should == false
    @rangeParser.parseRange('AK, KJs, 99, QJ-6, T4-2s, 53o, 87-3o, 66-22')
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
=begin
    @rangeManager.range.each_pair do |x,y|
      puts '-----'
      puts x
      puts y.inspect
      puts '-----'

    end
=end
  end

end
