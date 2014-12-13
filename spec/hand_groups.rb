require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../hand_groups.rb'
require '../range_manager.rb'

#one day i'll learn rspec for real
HandGroup = Struct.new('HandGroup', :hands) do
 def setType(_)
    self
  end
end

describe 'Hand Groups' do
  before(:each) do
    @rangeManager = RangeTools::RangeManager.new
    @rangeManager.populateRange('Q9-4,Q2sc,Q2cc,Q2sh,QJss,QJcc,QJdd,QJhh')
    @col = "QJ QT Q9 Q8 Q7 Q6 Q5 Q4 Q3 Q2".split(' ')
    @hg = RangeTools::HandGroups.new(@col, @rangeManager)
  end

  it 'has group hands method' do
    expected = [["QJ"], ["Q9", "Q8", "Q7", "Q6", "Q5", "Q4"], ["Q2cc"]]
    @hg.groupHands(@col, :suits).map {|g| g.hands}.should == expected
  end

  it 'groups offsuited hands' do
    expected = [["Q9", "Q8", "Q7", "Q6", "Q5", "Q4"], ["Q2sc", "Q2sh"]]
    @hg.groupHands(@col, :offsuits).map {|g| g.hands}.should == expected
  end
  it 'has inBothGruops method' do
    x = [['KJ'], ['QT', 'Q9'], ['AK']]
    y = [['AA', 'KK', 'QQ'], ['AJ'], ['QT', 'Q9'], ['AK'], ['88']]


    x = x.map {|a| HandGroup.new(a) }
    y = y.map {|a| HandGroup.new(a) }

    @hg.inBothGroups(x,y).map {|g| g.hands}.should == [["QT", "Q9"], ["AK"]]

  end

  it 'has remove duplicates method' do
    x = [['KJ'], ['QT', 'Q9'], ['AK']]
    y = [['AA', 'KK', 'QQ'], ['AJ'], ['QT', 'Q9'], ['AK'], ['88']]


    x = x.map {|a| HandGroup.new(a) }
    y = y.map {|a| HandGroup.new(a) }

    @hg.removeDuplicates(x,y).map {|g| g.hands}.should == [['KJ']]

  end

  it 'has to_s method' do
    @hg.to_s.should == 'Q9-4,QJs,Q2cc,Q2sc,Q2sh'
  end

end
