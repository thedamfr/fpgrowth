require 'test/unit'
require 'fpgrowth/miner/pattern'

class TestPattern < Test::Unit::TestCase

  def test_initialize
    pattern = nil
    assert_nothing_raised { pattern = FpGrowth::Miner::Pattern.new() }
    assert_equal(0, pattern.support)
    assert_equal([], pattern.content)

    assert_nothing_raised { pattern = FpGrowth::Miner::Pattern.new(['a', 'b', 'c'], 3) }
    assert_equal(['a', 'b', 'c'], pattern.content)
    assert_equal(3, pattern.support)

  end

  def test_add
    pattern = FpGrowth::Miner::Pattern.new(['a', 'b', 'c'], 3)
    pattern2 = FpGrowth::Miner::Pattern.new(['d', 'e'], 2)
    union = nil
    assert_nothing_raised { union = pattern + pattern2 }

    assert_equal(union.size, pattern.size + pattern2.size)
    assert_equal(5, union.size)
    assert_equal(['a', 'b', 'c', 'd', 'e'], union.content)
    assert_equal(pattern.content + pattern2.content, union.content)
    assert_equal(2, union.support)
  end

  def test_insert
    pattern = FpGrowth::Miner::Pattern.new(['a', 'b', 'c'], 3)
    node1 = FpGrowth::FpTree::Node.new('d', 2)
    node2 = FpGrowth::FpTree::Node.new('e', 3)

    node3 = FpGrowth::FpTree::Node.new('f', 1)
    node4 = FpGrowth::FpTree::Node.new('g', 2)
    node_array = [node3, node4]

    assert_nothing_raised { pattern << node1 }
    assert_equal('d', pattern.content.last)
    assert_equal(2, pattern.support)

    assert_nothing_raised { pattern << node2 }
    assert_equal('e', pattern.content.last)
    assert_equal(2, pattern.support)

    assert_nothing_raised { pattern << node_array }
    assert_equal('g', pattern.content[-1])
    assert_equal('f', pattern.content[-2])
    assert_equal(1, pattern.support)


  end

end