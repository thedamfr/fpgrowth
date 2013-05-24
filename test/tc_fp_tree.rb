require 'test/unit'
require "fpgrowth/fp_tree"
require "fpgrowth/fp_tree/node"

class TestFpTree < Test::Unit::TestCase

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

  # test initialize
  def test_initialize

    fp_tree = nil
    # no arguments
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new()}
    assert_not_nil( fp_tree.root )
    assert_instance_of( FpGrowth::FpTree::Node , fp_tree.root )
    assert_instance_of( Hash , fp_tree.heads )
    assert_equal( {} , fp_tree.supports )

    # list empty
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new({})}
    assert_not_nil( fp_tree.root )
    assert_instance_of( FpGrowth::FpTree::Node , fp_tree.root )
    assert_instance_of( Hash , fp_tree.heads )
    assert_equal( {} , fp_tree.supports )


    # list with arguments
    support =  { 'a' => 1, 'b' => 2}
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new(support)}
    assert_not_nil( fp_tree.root )
    assert_instance_of( FpGrowth::FpTree::Node , fp_tree.root )
    assert_instance_of( Hash , fp_tree.heads )
    assert( fp_tree.heads.has_key?('a') , "a n'existe pas")
    assert( fp_tree.heads.has_key?('b') ,"b n'existe pas !" )
    assert_equal( 2 , fp_tree.heads.length )
    assert( fp_tree.supports.has_key?('a') , "a n'existe pas")
    assert( fp_tree.supports.has_key?('b') ,"b n'existe pas !" )
    assert_equal( 2 , fp_tree.supports.length )

  end

  # test item_oder_lookup
  def test_item_oder_lookup

    # look up with fp_tree nul
    fp_tree = nil
    # no arguments
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new()}
    lookup = fp_tree.item_order_lookup
    assert_equal( {} , lookup )

    # look up with fp_tree non null
    support =  { 'a' => 1, 'b' => 2}
    assert_nothing_raised {fp_tree = FpGrowth::FpTree::FpTree.new(support)}
    lookup = fp_tree.item_order_lookup
    assert_equal( 0  , lookup['a'] )
    assert_equal( 1  , lookup['b'] )

  end

  # test  find_lateral_leaf_for_item
  def test_find_lateral_leaf_for_item

  end

end