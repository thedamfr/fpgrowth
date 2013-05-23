require 'test/unit'
require 'fpgrowth/fptree/builder/second_pass'
require 'fpgrowth/fptree/builder/first_pass'

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


    secondPass = FpGrowth::FpTree::Builder::SecondPass.new(@supports_random)

    for transaction in @random_transactions
        secondPass.sort_by_support(transaction)
    end

  end

end