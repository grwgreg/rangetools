require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../handevaluator.rb'


describe 'Hand Evaluator' do
  before(:each) do
    @handEvaluator = HandEvaluator.new
    @madeHands = {
      total: 0,
      straight_flush: [],
      quads: [],
      pocket_pair: [],
      premium_pocket: [],
      pair: ['KTcc'],
      straight: [],
      straight_on_board: [],
      oesd: [],
      doublegut: [],
      gutshot: [],
      pair_plus_gutshot: [],
      pair_plus_oesd: [],
      pair_plus_doublegut: [],
      pair_plus_flush_draw: [],
      flush: [],
      flush_draw: [],
      flush_on_board: [],
      flush_draw_on_board: [],
      two_pair: [],
      trips: ['QJds'],
      set: [],
      full_house: [],
      pair_plus_oesd: [],
      pair_plus_gut: [],
      pair_plus_over: [],
      pair_plus_flush: [],
      combo_draw: [],
      ace_high: [],
      over_cards: [],
      one_over_card: [],
      premium_overs: [],
      mid_pair: [],
      high_pair: [],
      low_pair: [],
      over_pair: [],
      pair_on_board: []
    }
  end

  it 'has evalhand method' do
    hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :c, tag: :'A', rank: 14}
      ]
    board = [
      {suit: :c, tag: :A, rank: 14},
      {suit: :h, tag: :K, rank: 13},
      {suit: :s, tag: :"3", rank: 3}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:pair].should == ['KTcc', 'AJch']
    result[:high_pair].should == ['AJch']

    hand = [
      {suit: :h, tag: :J, rank: 11},
      {suit: :c, tag: :A, rank: 14}
      ]
    board = [
      {suit: :d, tag: :J, rank: 11},
      {suit: :s, tag: :J, rank: 11},
      {suit: :s, tag: :"3", rank: 3}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:trips].should == ["QJds", "AJch"]

    hand = [
      {suit: :h, tag: :J, rank: 11},
      {suit: :c, tag: :A, rank: 14}
      ]
    board = [
      {suit: :d, tag: :'4', rank: 4},
      {suit: :s, tag: :'9', rank: 9},
      {suit: :s, tag: :"3", rank: 3}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:ace_high].should == ['AJch']
    result[:over_cards].should == ['AJch']
  end

end
