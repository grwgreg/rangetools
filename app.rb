require 'sinatra'
require 'pp'
require 'json'
require './range_manager.rb'
require './range_evaluator.rb'

set :bind, "0.0.0.0"

get '/:board/:range' do
	content_type :json
	headers 'Access-Control-Allow-Origin' => 'http://localhost:8080'
  puts params
  board = params['board']
  range = params['range']
	rangeManager = RangeTools::RangeManager.new
	rangeManager.populateRange(range)

	rangeEvaluator = RangeTools::RangeEvaluator.new(board)
	rangeEvaluator.evaluateRange(rangeManager.range)

	x = rangeEvaluator.rangeReport(rangeManager)
	x.to_json.to_json
end
