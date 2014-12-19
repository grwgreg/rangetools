#!/usr/bin/env ruby
require 'pp'
require 'json'
require './range_manager.rb'
require './range_evaluator.rb'

board = ARGV[0]
range = ARGV[1]

rangeManager = RangeTools::RangeManager.new
rangeManager.populateRange(range)

rangeEvaluator = RangeTools::RangeEvaluator.new(board)
rangeEvaluator.evaluateRange(rangeManager.range)

x = rangeEvaluator.rangeReport(rangeManager)
puts x.to_json
