require 'rubygems'
require 'bundler/setup'
require 'rspec'
require '../range_formatter.rb'
require '../range_manager.rb'

module RangeTools
  class RangeManager
    include RangeFormatter
  end
end

rangeManager = RangeTools::RangeManager.new

describe 'RangeFormatter module' do
  it 'parses populated range manager returns range string' do

  
  end
end
