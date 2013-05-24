require 'test/unit'
require "fpgrowth/fp_tree/node"

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

  # Test initialize
  def test_initialize
    # Test initialize for node = nil
    node = nil
    assert_nothing_raised {node = FpGrowth::FpTree::Node.new()}
    assert_equal( nil , node.item )
    assert_equal( 1 , node.support  )
    assert_equal( [] , node.children )
    assert_equal( nil , node.lateral)

    # Test initialize for node with first parameter
    assert_nothing_raised {node = FpGrowth::FpTree::Node.new(14)}
    assert_equal( 14 , node.item )
    assert_equal( 1 , node.support  )

    # Test initialize for node with two parameter
    assert_nothing_raised {node = FpGrowth::FpTree::Node.new( 14 , 32)}
    assert_equal( 14 , node.item )
    assert_equal( 32 , node.support  )

  end



end