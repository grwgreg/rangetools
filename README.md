RangeTools
===============

A Texas Holdem poker library and command line tool for evaluating the distribution of hand strength for a given set of hands ("range" in poker terminology) and known board cards.

Quick Start
-------------
```
$bundle install
$bundle exec rspec spec/*.rb 
$bundle exec range.rb 4s,5s,7c AA-JJ,87-4s,AK-Ts,KQ-J

{
"straight_flush": {
	"percent": 0,
	"percent_of_group": 0,
	"hands": [],
	"handRange": ""
	},
	.....
"pocket_pair": {
	"percent": 0.44036697247706424,
	"percent_of_group": 0.8421052631578947,
	"hands": [
		"JJcd",
		...
		],
	"handRange": "AA-J",
...full listing of hand strengths and the percent of total hands with this strength. Also grouped into more arbitrary but useful groupings like draws, pair+draws, premium hands etc
```
The above evaluates a flop of 4 of spades, 5 of spades, 7 of clubs against range of pocket  aces to jacks, AK,AQ,AJ,AT of suited combinations, 87,86,85,84 of suited combinations and KQ,KJ of all combinations. From the full output you will see only 3.7% of the range is a straight, 14.7% is only Ace high, 6.4% is a flush draw etc

------------
## Terminology
Terminology used within the program

**tag**: Any symbol representation of a card or cards. :AK is a tag for all combos of AK, :J is a tag for any card that is jack. This term is mostly used to distinguish itself from "card" hashes which have the full information about a specific card and from the range hash representation of AK, containing the suit combos of AK which are present in a range.

**singles**: Tokens which only represent a single hand like Ks5h. Within the tagBuckets hash they are a hash where the key is the tag and the value is an array of the combos. So Ks5h,Kd5h,Kc5c would have single: {K5: [:sh,:dh,:cc]}.

**hand group**: A hand group will be represented by a single token in the range string. So AK-T is the token and the hand group is AK,AQ,AJ,AT. Hand groups can either represent suited combos only, offsuits only, all combos, or a single hand. So the hand group for 76cs contains just that single hand.

**twoCardHand**: used throughout the program, is just an array of card hashes representing a single holdem hand, [{tag: :J, suit: :c, rank: 11}, {tag: :"5", suit: :d, rank: 5}]

**rank**: the numerical value for each hand so ten is 10, jack is 11, queen is 12, king 13 and ace 14.

**combo**: For any two card tag, the possible suit combinations for the tag are the combos for the tag. :cs is the combo where the leftmost card is a club and the rightmost card is a spade.

**rangeFormatter**: Unsure why I called this formatter, a better term may have been serializer. It just creates a string representation of the range object.

**range string**: A string representation of all the two card hands a player may be holding.

------------


## Range String Syntax
"87" is all suit combinations of 87, the higher card is always listed first so TJ is not a valid range string.
AK-8 is AK,AQ,AJ,...A8 of all suit combinations
AK-3s is AK,AQ,AJ,...A3 of only suited combinations (cc,dd,hh,ss)
QJ-7o is QJ,QT,Q9,...Q7 of only offsuit combinations (cd,ch,cs,dc,dh,ds,hc,hd,hs,sc,sd,sh)
88-44 is 88,77,66,55,44 of all combinations
JTcs represents the single hand of Jack of clubs, Ten of spades

The shorthand notation is optional, populateRange will accept any valid representation of a range (ie AA,KK,QQ will result in the same range as AA-Q and AKo,AKs,AKcs,AKdd,AKcc will result in the same as AK).


------------

## Use as a library
```ruby
range = "AK-2,KQ-T,QJ-9s,JT,98-7s,87-6s,AA-22"
rangeManager = RangeTools::RangeManager.new
rangeManager.populateRange(range)

board = "Qh,7h,6s"
rangeEvaluator = RangeTools::RangeEvaluator.new(board)
rangeEvaluator.evaluateRange(rangeManager.range)
```
After calling .evaluateRange, the @madeHands hash is populated with all the data about the strength of the individual hand values. You can either use this directly or use the .rangeReport method which returns a hash that loops through the @madeHands value and determines the percent of an overall range for each hand type. The rangeReport also adds some helpful new hand types which just merge some of the preexisting types. This is done so you can see what % of a range is draws, pair plus draws etc (see the rangeEvaluator.extraHandTypes method )

When hand types are part of one of these new merged hand types, the :percent_of_group will show what % of that specific group it makes up. So for example you can see what % of your draws are open ended straight draws (oesd) vs gutshots, in addition to seeing what % of your overall range is oesd.


------------

## Internal Details
The rangeManager has an @range attribute which holds all the possible 2card holdings in Texas holdem. It represents hands using a ruby hash where the key is an identifier for the ranks of the cards (internally called a tag). For example, the key of :KJ represents all the possible combinations of hands which are made up of king and a jack. The value for this key is another hash where each key represents the suits of the king and jack cards. Their value is set to true when that specific combination is present in a given range.

```ruby
  @rangeManager.range[:KJ][:cs] === true #King of clubs, Jacks of spades is in the range
  @rangeManager.range[:AJ][:dc] === true #Ace of diamonds, Jacks of clubs is in the range
```

The rangeManager has a few methods for setting and retrieving facts about which specific hands are present in a range. See spec/range_manager.rb for examples. Generally, these methods will not be used directly
because they are used internally by the populateRange method. The populateRange method takes a "range string" and sets all the individual combinations in the @range. The rangeManager also has a formatRange method which will output the range string representation of the current range.

The rangeEvaluator is responsible for determining the hand strength of the individual hands that make up a range. The @madeHands hash has hand strength types as keys (:straight,:flush,:flush_draw,etc) and the values are the individual hand tags from the range that have that value. So on KQT if our range contains AJs the @madeHands[:straight] == [AJss,AJcc,AJdd,AJhh].

The rangeEvaluator is initalized with a board string (or array of hashes representing cards, see tests) and then can have the evaluateRange method called, passing in a range hash (from the rangeManager's range attribute).

Some arbitrary logic is used in hand_evaluator.rb for determining when to include hands of a certain strength in the @madeHands hash. For example if a specific
hand has a pair but is also a made flush, I made the choice to not count the hand as having a pair. Draws are also not included if a hand has a straight or better. This may seem incorrect from an objective view of a range but from the viewpoint of wanting the best possible information for in game decisions I believe it is preferable. In a sense we're getting an estimate of their best made hand for each holding in their range instead of every hand value, avoiding double counting low value hands. I think it's important to not over represent how many draws are in a range since that is often relied on for estimating bluffing frequencies. It's actually still probably over estimating draws because two-pair and trips will also have draws included. The first few methods in hand_evaluator.rb determine what is included in the @madeHands hash so this is where to start looking if you want to adjust this functionality.


------------

### known bugs
Straight flush detection does not work. The problem is the straight detection and flush detection functions don't return any data about the rank of the hand, only the presence of any flush. These modules would need to return the highest rank from the flush/straight and if they were equal there would be a straight flush. 
