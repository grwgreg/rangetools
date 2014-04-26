require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../rangemanager.rb'

rangeManager = RangeManager.new

describe rangeManager do
  it 'has build range method called during init' do
    rangeManager.range.length.should == 91
    rangeManager.range[:"AK"].length.should == 16
    rangeManager.range[:"AA"].length.should == 12 
  end

  it 'has set all method' do
    rangeManager.setAll(:K3)
    rangeManager.range[:K3].each_value do |val|
      val.should == true
    end
    rangeManager.range[:K2][:cc].should == false
  end

  it 'has set suited method' do
    rangeManager.setSuited(:"QJ")
    rangeManager.range[:QJ][:cc].should == true
    rangeManager.range[:QJ][:cs].should == false
    rangeManager.range[:QJ][:ss].should == true
    rangeManager.range[:QJ][:ds].should == false
  end

  it 'has offset suited method' do
    rangeManager.setOffSuited(:"Q8")
    rangeManager.range[:Q8][:ss].should == false
    rangeManager.range[:Q8][:sc].should == true
    rangeManager.range[:Q8][:hh].should == false
    rangeManager.range[:Q8][:dc].should == true
  end

  it 'has setsinglehand method' do
    single = {AA: [:cs, :dc, :hs]}
    rangeManager.setSingleHand(single)
    rangeManager.range[:AA][:cd].should == false
    rangeManager.range[:AA][:cs].should == true
    rangeManager.range[:AA][:ds].should == false
    rangeManager.range[:AA][:dc].should == true
    rangeManager.range[:AA][:hs].should == true
  end
end
