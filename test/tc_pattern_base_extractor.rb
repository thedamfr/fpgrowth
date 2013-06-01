require 'test/unit'
require "fpgrowth/miner"
require "fpgrowth/fp_tree"


class TestPatternBaseExtractor < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    items= ['a', 'b', 'c', 'd', 'e']
    @supports_exemple = {'a' => 1, 'b' => 5, 'c' => 4}
    @tableau_pattern = []
    @tableau_pattern << FpGrowth::Miner::Pattern.new(["b"], 3 )



    @transactions = [['b', 'a'], ['b'], ['b', 'c'], ['a', 'b'],['b', 'c'],['b', 'c']]

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
    assert_equal(true , pattern_base_extractor.test_patterns([]) )

    #initialisation avec deux arguments
    fp_tree = nil
    assert_nothing_raised { fp_tree = FpGrowth::FpTree::FpTree.new(@supports_exemple) }
    assert_nothing_raised { pattern_base_extractor = FpGrowth::Miner::PatternBaseExtractor.new(fp_tree, 1) }
    assert_equal(true , pattern_base_extractor.test_tree(fp_tree))
    assert_equal(true , pattern_base_extractor.test_conditionnal_item(1))
    assert_equal(true , pattern_base_extractor.test_patterns )
  end

  # Tree must be built
  def test_execute

    pattern_base_extractor = nil
    pattern_result = nil
    #One argument
    assert_nothing_raised { pattern_base_extractor = FpGrowth::Miner::PatternBaseExtractor.new(1) }
    assert_nothing_raised { pattern_result =  pattern_base_extractor.execute}
    assert_equal(true , pattern_base_extractor.test_patterns(pattern_result) )

    #Two arguments
    fp_tree = nil
    fp_tree = FpGrowth::FpTree.build(@transactions, 1)
    assert_nothing_raised { pattern_base_extractor = FpGrowth::Miner::PatternBaseExtractor.new(fp_tree, 'c') }
    assert_nothing_raised { pattern_result =  pattern_base_extractor.execute}

    assert_equal( @tableau_pattern[1] , pattern_result[1])
    assert_equal(true , pattern_base_extractor.test_patterns(pattern_result) )

  end

  def test_horizontal_traversal

    # Test unit with execute
  end

  def test_horizontal_traversal_step
    pattern_base_extractor = nil
    fp_tree = nil
    fp_tree = FpGrowth::FpTree.build(@transactions)

    assert_nothing_raised { pattern_base_extractor = FpGrowth::Miner::PatternBaseExtractor.new(fp_tree, 'c') }
    assert_nothing_raised { pattern_base_extractor.horizontal_traversal_step (fp_tree.heads['c']) }
    assert_equal(true , pattern_base_extractor.test_min_support(fp_tree.heads['c'].support) )

    # attente

  end

  def down_to_top_traversal
    current_branch = nil
    pattern_base_extractor = nil
    fp_tree = FpGrowth::FpTree.build(@transactions)

    assert_nothing_raised { pattern_base_extractor = FpGrowth::Miner::PatternBaseExtractor.new(fp_tree, 'c') }
    assert_nothing_raised { current_branch = pattern_base_extractor.down_to_top_traversal( [] , fp_tree.heads['c'].support ) }

    assert_equal( [] , current_branch)

    fail('Rhaaaaaaaaaaa')
    #assert_equal(true , pattern_base_extractor.test_min_support(fp_tree.heads['c'].support) )
    #assert_equal(true , pattern_base_extractor.test_min_support(fp_tree.heads['c'].support) )
    #assert_equal(true , pattern_base_extractor.test_min_support(fp_tree.heads['c'].support) )
    #assert_equal(true , pattern_base_extractor.test_min_support(fp_tree.heads['c'].support) )
    #assert_equal(true , pattern_base_extractor.test_min_support(fp_tree.heads['c'].support) )


  end

  def down_to_top_traversal_step

  end

end