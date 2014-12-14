require 'rubygems'
require 'bundler/setup'
require 'rspec'
require './range_manager.rb'


describe 'RangeTools::RangeManager' do
  before(:each) do
    @rangeManager = RangeTools::RangeManager.new
  end
  it 'has build range method called during init' do
    @rangeManager.range.length.should == 91
    @rangeManager.range[:"AK"].length.should == 16
    @rangeManager.range[:"AA"].length.should == 12
  end

  it 'has set all method' do
    @rangeManager.setAll(:K3)
    @rangeManager.range[:K3].each_value do |val|
      val.should == true
    end
    @rangeManager.range[:K2][:cc].should == false
  end

  it 'has set suited method' do
    @rangeManager.setSuited(:"QJ")
    @rangeManager.range[:QJ][:cc].should == true
    @rangeManager.range[:QJ][:cs].should == false
    @rangeManager.range[:QJ][:ss].should == true
    @rangeManager.range[:QJ][:ds].should == false
  end

  it 'has offset suited method' do
    @rangeManager.setOffSuited(:"Q8")
    @rangeManager.range[:Q8][:ss].should == false
    @rangeManager.range[:Q8][:sc].should == true
    @rangeManager.range[:Q8][:hh].should == false
    @rangeManager.range[:Q8][:dc].should == true
  end

  it 'has setsinglehand method' do
    single = [:AA, [:cs, :dc, :hs]]
    @rangeManager.setSingleHand(single[0], single[1])
    @rangeManager.range[:AA][:cd].should == false
    @rangeManager.range[:AA][:cs].should == true
    @rangeManager.range[:AA][:ds].should == false
    @rangeManager.range[:AA][:dc].should == true
    @rangeManager.range[:AA][:hs].should == true
  end

  it 'has resetAll method set all combos to false' do
    single = [:AA, [:cs, :dc, :hs]]
    @rangeManager.setSingleHand(single[0], single[1])
    @rangeManager.setOffSuited(:"Q8")
    @rangeManager.setAll(:K3)
    @rangeManager.setSuited(:"QJ")
    @rangeManager.range[:AA][:cs].should == true
    @rangeManager.range[:K3][:cs].should == true

=begin
puts 'rangebefore'
puts @rangeManager.range
puts 'rangebefore'
    @rangeManager.resetAll
puts 'rangebafter'
puts @rangeManager.range
puts 'rangebeafter'
=end
    @rangeManager.resetAll
    @rangeManager.range[:AA][:cs].should == false
    @rangeManager.range[:K3][:cs].should == false
    @rangeManager.range[:Q8][:cs].should == false

  end

  it 'has process tagbuckets method' do
    tagBuckets = {
    single:  {AA: [:cs, :dc, :hs], KJ: [:ss, :hh]},
    both:  [:KT, :"77", :QJ],
    suited: [:"88", :"A4"],
    offsuited: [:"43", :JT],
    }
    @rangeManager.processTagBuckets(tagBuckets)

    @rangeManager.range[:AA][:cs].should == true
    @rangeManager.range[:KT][:ds].should == true
    @rangeManager.range[:"88"][:cs].should == false
    @rangeManager.range[:"88"][:cc].should == true
    @rangeManager.range[:"43"][:cc].should == false
    @rangeManager.range[:"43"][:cd].should == true

=begin
    puts '----'
    puts @rangeManager.range.inspect
    puts '----'
=end
  end

  it 'has populate range method' do
    @rangeManager.range[:AK][:cc].should == false
    @rangeManager.populateRange('AK, 87')
    @rangeManager.range[:AK][:cc].should == true
=begin
    puts '----'
    puts @rangeManager.range[:AK].inspect
    puts '----'
=end
  end
end
