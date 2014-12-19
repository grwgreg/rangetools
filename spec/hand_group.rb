require 'rubygems'
require 'bundler/setup'
require 'rspec'
require './hand_group.rb'


describe 'Hand Group' do
  before(:each) do
    group = ["AK", "AQ", "AJ", "AT"]
    @hg = RangeTools::HandGroup.new(group, :offsuits)
  end

  it 'has working to_s method' do
    @hg.to_s.should == 'AK-To'

    group = ["AK"]
    @hg = RangeTools::HandGroup.new(group, :offsuits)
    @hg.to_s.should == 'AKo'

    group = ["AK"]
    @hg = RangeTools::HandGroup.new(group, :suits)
    @hg.to_s.should == 'AKs'

    group = ["AK"]
    @hg = RangeTools::HandGroup.new(group)
    @hg.to_s.should == 'AK'

    group = ["AK", "AQ"]
    @hg = RangeTools::HandGroup.new(group)
    @hg.to_s.should == 'AK-Q'

    group = ["AKcs", "AQss"]
    @hg = RangeTools::HandGroup.new(group)
    @hg.to_s.should == 'AKcs,AQss'
  end

end
