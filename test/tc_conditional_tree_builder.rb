require 'test/unit'
require "fpgrowth/miner"
require "fpgrowth/fp_tree"

class TestConditionalTreeBuilder < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup

    @tableau_pattern = []
    @tableau_pattern << FpGrowth::Miner::Pattern.new(['a', 'b'], 2)
    @tableau_pattern << FpGrowth::Miner::Pattern.new(['a', 'b', 'c'], 2)
    @tableau_pattern << FpGrowth::Miner::Pattern.new(['b', 'c'], 1)

    @tableau_pattern_one_element = []
    @tableau_pattern_one_element << FpGrowth::Miner::Pattern.new(['a'], 12)

    @supports_exemple = {'a' => 1, 'b' => 5, 'c' => 4}
    @supports_exemple_for_pruning = {'a' => 4, 'b' => 5, 'c' => 3}

    @pattern_exemple = FpGrowth::Miner::Pattern.new(['a', 'b'], 2)
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  #  test initialiser
  def test_initialize
    conditional_tree_builder = nil

    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new() }
    assert_equal(true, conditional_tree_builder.test_execute_threshold(1))
    assert_equal(true, conditional_tree_builder.test_execute_pattern_base())

    #initialisation avec un argument

    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new(@tableau_pattern) }
    assert_equal(true, conditional_tree_builder.test_execute_pattern_base(@tableau_pattern))
    assert_equal(true, conditional_tree_builder.test_execute_threshold)

    #initialisation avec deux arguments

    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new(@tableau_pattern, 3) }
    assert_equal(true, conditional_tree_builder.test_execute_pattern_base(@tableau_pattern))
    assert_equal(true, conditional_tree_builder.test_execute_threshold(3))

  end


  def test_execute

    # no argument
    conditional_tree_builder = nil
    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new() }
    assert_nothing_raised { conditional_tree_builder.execute }
    assert_equal(true, conditional_tree_builder.test_execute_threshold(1))
    assert_equal(true, conditional_tree_builder.test_execute_pattern_base())

    # One element
    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new(@tableau_pattern_one_element , 1) }
    assert_nothing_raised { conditional_tree_builder.execute }
    assert_equal(true, conditional_tree_builder.test_execute_threshold(1))
    assert_equal(true, conditional_tree_builder.test_execute_pattern_base(@tableau_pattern_one_element))

    # Three element
    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new(@tableau_pattern , 1) }
    assert_nothing_raised { conditional_tree_builder.execute }
    assert_equal(true, conditional_tree_builder.test_execute_threshold(1))
    assert_equal(true, conditional_tree_builder.test_execute_pattern_base(@tableau_pattern))

  end

  def test_second_pass
    # Test unit impossible (Fp-tree)

  end

  def test_first_pass
    # no elements
    conditional_tree_builder = nil
    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new() }
    assert_nothing_raised { conditional_tree_builder.first_pass}
    assert_equal(true, conditional_tree_builder.test_execute_threshold(1))
    assert_equal(true, conditional_tree_builder.test_execute_pattern_base())

    #One element
    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new(@tableau_pattern_one_element , 1) }
    assert_nothing_raised { conditional_tree_builder.first_pass}
    assert_equal(true, conditional_tree_builder.test_execute_threshold(1))
    assert_equal(true, conditional_tree_builder.test_execute_pattern_base(@tableau_pattern_one_element))

    #Three element
    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new(@tableau_pattern , 1) }
    assert_nothing_raised { conditional_tree_builder.first_pass}
    assert_equal(true, conditional_tree_builder.test_execute_threshold(1))
    assert_equal(true, conditional_tree_builder.test_execute_pattern_base(@tableau_pattern))

  end

  def test_scan

    # with no argument
    conditional_tree_builder = nil
    supports = nil
    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new() }
    assert_nothing_raised { supports = conditional_tree_builder.scan() }
    assert_equal(Hash.new(0), supports)

    #with one argument
    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new(@tableau_pattern) }
    assert_nothing_raised { supports = conditional_tree_builder.scan() }
    assert_equal(4, supports['a'])
    assert_equal(5, supports['b'])
    assert_equal(3, supports['c'])

  end

  def test_pruning

    conditional_tree_builder = nil
    support_prining = nil

    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new() }
    # with arguments
    supports = @supports_exemple
    pattern_base = @tableau_pattern_one_element
    supports_pruning = nil
    assert_nothing_raised {supports_pruning = conditional_tree_builder.pruning(pattern_base , supports , 1)}

    # There must be no pruning, considering the very few element there is
    assert_equal(3, supports_pruning.size, "Supports : "+@support_non_random.to_s)

    # with arguments
    supports = @supports_exemple
    pattern_base = @tableau_pattern_one_element
    supports_pruning = nil
    assert_nothing_raised {supports_pruning = conditional_tree_builder.pruning(pattern_base , supports , 33)}

    assert_equal(2, supports_pruning.size, "Supports : "+@support_non_random.to_s)
    assert_equal(5, supports_pruning['b'])
    assert_equal(4, supports_pruning['c'])

    supports = @supports_exemple_for_pruning
    pattern_base = @tableau_pattern
    supports_pruning = conditional_tree_builder.pruning(pattern_base , supports , 1 )
    assert_equal(4, supports_pruning['a'])
  end

  def test_sort
    conditional_tree_builder = nil
    supports = nil

    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new() }


    #with one argument
    assert_nothing_raised { supports = conditional_tree_builder.sort(@supports_exemple) }
    assert_equal(1, supports['a'])
    assert_equal(5, supports['b'])
    assert_equal(4, supports['c'])
    assert_equal('b', supports.keys[0])
    assert_equal('c', supports.keys[1])
    assert_equal('a', supports.keys[2])
  end

  def test_sort_by_support
    conditional_tree_builder = nil
    pattern_base = nil
    fp_tree = nil
    # One element
    assert_nothing_raised { fp_tree = FpGrowth::FpTree::FpTree.new(@supports_exemple) }
    assert_nothing_raised { conditional_tree_builder = FpGrowth::Miner::ConditionalTreeBuilder.new(@tableau_pattern_one_element) }
    assert_nothing_raised { pattern_base = conditional_tree_builder.sort_by_support(@tableau_pattern_one_element.first, fp_tree) }
    assert_equal(@tableau_pattern_one_element.first, pattern_base)

    #Two element
    assert_nothing_raised { pattern_base = conditional_tree_builder.sort_by_support(@pattern_exemple, fp_tree) }

    assert_equal(['b', 'a'], pattern_base.content, "en plus, #{fp_tree.supports.to_s}")
    assert_equal(2, pattern_base.support)

    #Three element
    assert_nothing_raised { pattern_base = conditional_tree_builder.sort_by_support(FpGrowth::Miner::Pattern.new(['a','b','c'],2), fp_tree) }

    assert_equal(['b', 'c', 'a'], pattern_base.content, "en plus, #{fp_tree.supports.to_s}")
    assert_equal(2, pattern_base.support)
  end

  def test_traverse
    # Test unit impossible
  end

  def test_fork_pattern
    # Test unit impossible (like traverse )
  end

  def test_continue_pattern
    # Test unit impossible (like traverse )
  end

end