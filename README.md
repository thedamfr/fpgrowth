# Fp-Growth-Ruby

Ruby implementation of FP-Growth

## Installation

Add this line to your application's Gemfile:

    gem 'fpgrowth-ruby'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fp-growth-ruby

## Usage

Build a tree from transactions:

```ruby
transactions = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]
fptree = FpGrowth::FpTree.build(transactions)

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
