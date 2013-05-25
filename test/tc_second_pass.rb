require 'test/unit'
require 'fpgrowth/fp_tree/builder/second_pass'
require 'fpgrowth/fp_tree/builder/first_pass'


class TestSecondPass < Test::Unit::TestCase


  def setup
    items= ['a', 'b', 'c', 'd', 'e']

    r = Random.new

    @n = r.rand(100..500)

    @random_transactions = []
    for i in (0..@n)


      @m = r.rand(1..5)
      @random_transactions[i]=[]
      for j in (0..@m)
        x = r.rand(10)
        if x == 9
          # Trick pour que le 'e' se fasse pruner
        then
          @random_transactions[i] << items[r.rand(items.size)]
        else
          @random_transactions[i] << items[r.rand(items.size - 1)]
        end
      end

    end

    @non_random = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]


    firstPass = FpGrowth::FpTree::Builder::FirstPass.new()

    @supports_random = firstPass.execute(@random_transactions)
    @supports_non_random = firstPass.execute(@non_random)
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_sort_by_support

    secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_non_random)

    support_sorted = []


    for transaction in @non_random
      support_sorted << secondPass.sort_by_support(transaction)
    end

    assert_equal(@supports_non_random.keys.first, support_sorted.first.first)
    assert_equal(@supports_non_random.keys[1], support_sorted.first[1])


    secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_random)

    for transaction in @random_transactions
      secondPass.sort_by_support(transaction)
    end


  end

  def test_continue_pattern
    parent = FpGrowth::FpTree::Node.new('a')
    secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_non_random)

    transaction = ['a', 'b']

    assert_nothing_raised() { secondPass.continue_pattern(parent, transaction) }
    assert_equal(2, parent.support)

  end

  def test_fork_pattern
    parent = FpGrowth::FpTree::Node.new(nil)
    secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_non_random)

    transaction = ['a', 'b']

    assert_nothing_raised() { secondPass.fork_pattern(parent, transaction) }
    assert_equal('a', parent.children.last.item)
    assert_equal('b', parent.children.last.children.first.item)

    # Test 2

    parent = FpGrowth::FpTree::Node.new('a')
    secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_non_random)

    transaction = ['a', 'a', 'b']

    assert_nothing_raised() { secondPass.fork_pattern(parent, transaction) }
    assert_equal('a', parent.children.last.item)
    assert_equal(2, parent.children.last.support)
    assert_equal('b', parent.children.last.children.first.item)


  end

  def test_traverse

    parent = FpGrowth::FpTree::Node.new(nil)
    secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_non_random)

    transaction = ['a', 'a', 'b']

    assert_nothing_raised() { secondPass.traverse(parent, transaction) }
    assert_equal(2, parent.children.first.support)
    assert_equal('a', parent.children.first.item)

    assert_equal('b', parent.children.first.children.first.item)
    assert_equal(1, parent.children.first.children.first.support)

  end

  def test_initialize
    secondPass = nil
    assert_nothing_raised { secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_non_random) }

    assert_not_nil(secondPass.fp_tree)
    assert_equal(@supports_non_random.keys, secondPass.fp_tree.heads.keys)
    assert_equal(@supports_non_random, secondPass.fp_tree.supports)
  end

  def test_execute
    secondPass = nil
    assert_nothing_raised { secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_non_random) }

    assert_nothing_raised { secondPass.execute(@non_random) }
    for key in secondPass.fp_tree.heads.keys
      assert_not_nil(secondPass.fp_tree.heads[key])
    end


  end

end