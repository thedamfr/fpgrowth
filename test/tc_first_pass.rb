require 'test/unit'
require 'fpgrowth/fp_tree/builder/first_pass'

class TestFirstPass < Test::Unit::TestCase

  # Generer une liste de transaction aléatoire
  #
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

    @support_random = firstPass.scan(@random_transactions)

    @support_non_random = firstPass.scan(@non_random)
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  #
  def teardown
    # Do nothing
  end

  # test_scan
  def test_scan

    assert_equal(2, @support_non_random['a'])
    assert_equal(4, @support_non_random['b'])
    assert_equal(1, @support_non_random['c'])

    assert_equal(5, @support_random.size)
    for val in @support_random.values
      assert_operator(@n * 5, ">=", val)
    end
  end

  def test_pruning

    firstPass = FpGrowth::FpTree::Builder::FirstPass.new()

    @support_random_pruned = firstPass.pruning(@support_random)
    @support_non_random_pruned = firstPass.pruning(@support_non_random)

    # There must be no pruning, considering the very few element there is
    assert_equal(3, @support_non_random.size)

    assert_operator(5, ">", @support_random.size)
  end

  def test_sort
    firstPass = FpGrowth::FpTree::Builder::FirstPass.new()

    @support_random_sorted = firstPass.sort(@support_random)
    @support_non_random_sorted = firstPass.sort(@support_non_random)

    assert_equal('b',@support_non_random_sorted.keys[0])
    assert_equal('a',@support_non_random_sorted.keys[1])

    for i in (0..(@support_random_sorted.keys.size - 2))
      assert_operator(@support_random_sorted[@support_random_sorted.keys[i]], ">=" , @support_random_sorted[@support_random_sorted.keys[i+1]])
    end

  end

  def test_execute
    firstPass = FpGrowth::FpTree::Builder::FirstPass.new()

    non_random_first_passed = firstPass.execute(@non_random)
    random_first_passed = firstPass.execute(@random_transactions)

    assert_instance_of(Hash, non_random_first_passed)
    assert_instance_of(Hash, random_first_passed)

    assert_equal(3, non_random_first_passed.size)
    assert_equal(4, random_first_passed.size)
  end

end