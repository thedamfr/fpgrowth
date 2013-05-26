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
    assert_nothing_raised { node = FpGrowth::FpTree::Node.new() }
    assert_equal(nil, node.item)
    assert_equal(1, node.support)
    assert_equal([], node.children)
    assert_equal(nil, node.lateral)

    # Test initialize for node with first parameter
    assert_nothing_raised { node = FpGrowth::FpTree::Node.new(14) }
    assert_equal(14, node.item)
    assert_equal(1, node.support)

    # Test initialize for node with two parameter
    assert_nothing_raised { node = FpGrowth::FpTree::Node.new(14, 32) }
    assert_equal(14, node.item)
    assert_equal(32, node.support)

  end

  def test_clone_tail_deep
    node = FpGrowth::FpTree::Node.new('a')

    nodeChild10 = FpGrowth::FpTree::Node.new('b')
    nodeChild11 = FpGrowth::FpTree::Node.new('b')
    nodeChild12 = FpGrowth::FpTree::Node.new('b')

    node.children += [nodeChild10, nodeChild11, nodeChild12]

    nodeChild20 = FpGrowth::FpTree::Node.new('c')
    nodeChild21 = FpGrowth::FpTree::Node.new('c')
    nodeChild22 = FpGrowth::FpTree::Node.new('c')


    node.children.first.children += [nodeChild20, nodeChild21, nodeChild22]

    assert_equal(nodeChild11, nodeChild12)

    result = nil

    assert_nothing_raised { result = node.clone_tail_deep }

    for i in (0..result.size-1)
      assert_not_same(node.children[i], result[i])
      assert_equal(node.children[i], result[i])
    end

    assert_not_same(node.children, result)
    assert_equal(node.children, result)


    node = node.children.first
    result = result.first.children

    assert_not_same(node.children, result)
    assert_equal(node.children, result)
    for i in (0..result.size-1)
      assert_not_same(node.children[i], result[i])
      assert_equal(node.children[i], result[i])
    end

  end

  def test_equal
    fail("To Do")
  end

  def test_clone
    fail("To Do")
  end

end