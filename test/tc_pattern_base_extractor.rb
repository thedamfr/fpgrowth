require 'test/unit'
require "fpgrowth/miner"
require "fpgrowth/fp_tree"

class TestPatternBaseExtractor < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup

    @supports_exemple = {'a' => 1, 'b' => 5, 'c' => 4}
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end


  def test_initialize
    pattern_base_extractor = nil
    #initialisation avec un argument
    assert_nothing_raised { pattern_base_extractor = FpGrowth::Miner::PatternBaseExtractor.new(1) }
    assert_equal(true , pattern_base_extractor.test_tree())
    assert_equal(true , pattern_base_extractor.test_conditionnal_item(1))
    #assert_equal(true , pattern_base_extractor.test_patterns )

    #initialisation avec deux arguments
    fp_tree = nil
    #assert_nothing_raised { fp_tree = FpGrowth::FpTree::FpTree.new(@supports_exemple) }
    #assert_nothing_raised { pattern_base_extractor = FpGrowth::Miner::PatternBaseExtractor.new(fp_tree, 1) }
    #assert_equal(true , pattern_base_extractor.test_tree())
    #assert_equal(true , pattern_base_extractor.test_conditionnal_item(1))
    #assert_equal(true , pattern_base_extractor.test_patterns )
  end



  def test_horizontal_traversal

  end

  def test_traversal_step

  end

  def down_to_top_traversal

  end

  def down_to_top_traversal_step

  end
end