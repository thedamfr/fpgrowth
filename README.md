# Fp-Growth-Ruby

Ruby implementation of FP-Growth

## What's FP-Growth

FP-Growth is an algorithm used for mining frequent pattern in an item set. Such pattern are then used to build association rules.
Literature example is { Potatoes, Onions } => { Burger } or { Beer, Chips } => { Dippers }.

FP-Growth is known as a solution for Mining without Candidate generation (<http://dl.acm.org/citation.cfm?id=335372>).
Main alternative to FP-Growth is A Priori which is a pretty much a naive solution. A Priori consist in generating candidate then scanning the database looking for them.

FP-Growth solution is about reducing the database in one simple Tree Structure : The FP-Tree. The FP-Tree make easy to extract frequent pattern from it.
Then FP-Growth algorithm is about Extracting pattern from the tree, starting by the smallest, at the leafs of the tree and then making them grow until every pattern has been found.

## When use FP-Growth ?

FP-Growth is about working on a very large number of transactions. The FpTree building is a single pass linear operation.
Most of the time, FP-Growth operation is a 0(h²) operation, where h is the height of the Tree. By design, the height is the maximal length of the pattern.

Worst case is a DataSet with long transactions and where each item is significantly frequent. Such a tree is very big and reduction factor is very low. Performances would be... not what you expect ^^

## So why use FP-Growth in Ruby ?

Imagine a web app allowing you to connect to other users. Such a website want to help the user to engage with other. It will scan relationship of users and make suggestions like : "People who connect with following persons often connect with thoses persons".

Imagine a commercial website showing some products to the users. It will scan users actions and make suggestions like : "People who like this products often like this other one !"

Those applications are now easy thanks to fpgrowth for Ruby !

# Installation

Add this line to your application's Gemfile:

    gem 'fpgrowth'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fp-growth-ruby

## Usage

### Basic Usage

Just do it :

```ruby
transactions = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]
patterns = FpGrowth.mine(transactions)
```

### Advanced Usage


Build a tree from transactions and mine it

```ruby
transactions = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]
fp_tree = FpGrowth::FpTree.build(transactions)
FpGrowth::Miner.td_fp_growth(fp_tree)

```

By default, threshold for an item to be considered as "frequent" is 1% of the transactions.
You can edit the threshold when building the tree. We recommend using a threshold around 1%.
The larger is the number of transactions, the smaller should be the threshold. If tree is too large, you should use a higher threshold.

```ruby
transactions = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]
fp_tree = FpGrowth::FpTree.build(transactions, 30)
# 30 stands for 30% of transactions. Here, 'c' would be pruned.
FpGrowth::Miner.td_fp_growth(fp_tree)

```

If you want to avoid worst case, then you should make it a Bonzai !
```ruby
transactions = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]
fp_tree = FpGrowth::FpTree.build(transactions, 30)
bonzai = fp_tree.to_bonzai(20)
FpGrowth::Miner.td_fp_growth(bonzai)

```
20 stands for a hardness of 20%. It mean that a node is cut from the tree if it's not greater than 20% of it's father support.

There is two variant of FP-Growth.
The first one is the TopDown, it's the most efficient, in most cases.
For some reasons, it's alternative, the classical FpGrowth, it might be more efficient on a very small set.
Use it this way :
```ruby
transactions = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]
patterns = FpGrowth.fp_growth(transactions)
```
or
 ```ruby
 transactions = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]
 fp_tree = FpGrowth::FpTree.build(transactions, 30)
 bonzai = fp_tree.to_bonzai(20)
 FpGrowth::Miner.fp_growth(bonzai)

 ```



### Examples

You can find in the test repository a few concrete example on Open Data.


## Development : Next steps

As we said, worst case is a is a DataSet with long transactions and where each item is significantly frequent. Solution would be to higher the threshold level, which would result in data-loss, maybe critical data would be lost...

A better solution, described is following articles : [<http://dl.acm.org/citation.cfm?id=1133907> , <http://link.springer.com/chapter/10.1007/978-3-540-24775-3_19>]
Main concept is pruning the tree, once built in order to remove the less significant patterns. This is necessary to allow developer to prune his tree, losing least frequent pattern, in order to quickly obtain the most frequent ones.

This is next step in our Roadmap.

This is also a necessary step for allowing a Top-Down FP-Growth implementation as described in : <http://link.springer.com/chapter/10.1007/3-540-47887-6_34>

This last implementation is more scalable and more efficient than the current one.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
