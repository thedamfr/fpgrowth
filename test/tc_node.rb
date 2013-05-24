require 'test/unit'
require "fpgrowth/fptree/node"

class TestNode < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_initialize
    node = nil
    assert_nothing_raised {node = FpGrowth::FpTree::Node.new('a')}

    assert_equal('a',node.item )

    # To change this template use File | Settings | File Templates.

  end
end