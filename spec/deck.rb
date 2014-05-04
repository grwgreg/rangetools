require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../deck.rb'

deck = Deck.new
describe deck do
  it 'has 52 card objects in cards array' do
    deck.cards.length.should == 52
  puts deck.cards
  end

  it 'has shuffle method' do
    first = deck.cards[0]
    deck.shuffle!
    deck.cards[0].should_not == first
  end
end

