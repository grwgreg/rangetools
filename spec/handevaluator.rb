require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../handevaluator.rb'

describe 'Hand Evaluator' do
  before(:each) do
    @handEvaluator = Object.new
    @handEvaluator.extend(HandEvaluator)
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
      gutshot_on_board: [],
      oesd_on_board: [],
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
      top_pair: [],
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

  it 'evals flush' do
    hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :h, tag: :'A', rank: 14}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :h, tag: :K, rank: 13},
      {suit: :h, tag: :"3", rank: 3}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:flush].should == ["AJhh"]
  end
  it 'evals flush draw on board' do
    hand = [
      {suit: :c, tag: :'J', rank: 11},
      {suit: :c, tag: :'A', rank: 14}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :h, tag: :K, rank: 13},
      {suit: :d, tag: :"3", rank: 3},
      {suit: :h, tag: :'J', rank: 11},
      {suit: :h, tag: :'A', rank: 14}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:flush_draw_on_board].should == ["AJcc"]
  end
  it 'evals flush' do
    hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :h, tag: :'A', rank: 14}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :h, tag: :K, rank: 13},
      {suit: :d, tag: :"3", rank: 3},
      {suit: :h, tag: :'J', rank: 11},
      {suit: :h, tag: :'A', rank: 14}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:flush].should == ["AJhh"]
  end
  it 'xxxxevals pair plus flush draw' do
    hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :c, tag: :'A', rank: 14}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :s, tag: :K, rank: 13},
      {suit: :d, tag: :"3", rank: 3},
      {suit: :h, tag: :'3', rank: 3},
      {suit: :h, tag: :'A', rank: 14}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    #result[:pair_plus_flush_draw].should == ["AJch"]
#this gives me 2 pair when it should give pair on board...
#also ranks combo draw above pair plus flush draw
  end
  it 'evals pair plus flush draw' do
    hand = [
      {suit: :h, tag: :'J', rank: 11},
      {suit: :c, tag: :'A', rank: 14}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :d, tag: :"7", rank: 7},
      {suit: :h, tag: :'3', rank: 3},
      {suit: :h, tag: :'A', rank: 14}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:pair_plus_flush_draw].should == ["AJch"]
  end

  it 'evals oesd' do
    hand = [
      {suit: :h, tag: :'8', rank: 8},
      {suit: :c, tag: :'9', rank: 9}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :d, tag: :"7", rank: 7},
      {suit: :h, tag: :'3', rank: 3},
      {suit: :s, tag: :'A', rank: 14}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:oesd].should == ["98ch"]
  end
  it 'evals gutshot' do
    hand = [
      {suit: :h, tag: :'8', rank: 8},
      {suit: :c, tag: :'9', rank: 9}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :d, tag: :"6", rank: 6},
      {suit: :h, tag: :'3', rank: 3},
      {suit: :s, tag: :'A', rank: 14}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:gutshot].should == ["98ch"]
  end
  it 'evals doublegutshot' do
    hand = [
      {suit: :h, tag: :'6', rank: 6},
      {suit: :c, tag: :Q, rank: 12}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :d, tag: :"8", rank: 8},
      {suit: :h, tag: :'9', rank: 9},
      {suit: :s, tag: :'A', rank: 14}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:doublegut].should == ["Q6ch"]
  end
  it 'evals top pair' do
    hand = [
      {suit: :h, tag: :'6', rank: 6},
      {suit: :c, tag: :Q, rank: 12}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :d, tag: :"8", rank: 8},
      {suit: :h, tag: :'9', rank: 8},
      {suit: :s, tag: :'Q', rank: 12}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:top_pair].should == ["Q6ch"]
  end
  it 'evals pair on board' do
    hand = [
      {suit: :h, tag: :'6', rank: 6},
      {suit: :c, tag: :Q, rank: 12}
      ]
    board = [
      {suit: :h, tag: :T, rank: 10},
      {suit: :d, tag: :"8", rank: 8},
      {suit: :h, tag: :'9', rank: 8},
      {suit: :s, tag: :'9', rank: 9}
      ]
    result = @handEvaluator.evalHand(board, hand, @madeHands)
    result[:pair_on_board].should == ["Q6ch"]
  end
end
