require 'test/unit'
require 'fpgrowth/miner/conditional_tree_builder'

class TestConditonalTreeBuilder < Test::Unit::TestCase

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

  def test_execute
    fp_tree = FpGrowth::FpTree.build([['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']], 0)
    conditional_tree = nil


    assert_nothing_raised { conditional_tree = FpGrowth::Miner::ConditionalTreeBuilder.new(fp_tree, 'a').execute }

    fp_tree.graphviz()
    conditional_tree.graphviz("conditional")


    assert_equal('b', conditional_tree.root.children.first.item)
    assert_equal(2, conditional_tree.root.children.first.support)
    assert_equal([], conditional_tree.root.children.first.children)

    assert_equal(true, conditional_tree.single_path?)



  end
end