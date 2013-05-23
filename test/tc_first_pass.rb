require 'test/unit'
require 'fpgrowth/fptree/builder/first_pass'

class TestFirstPass < Test::Unit::TestCase

  # Generer une liste de transaction aléatoire
  #
  def setup

    items= ['a', 'b', 'c', 'd', 'e']

    r = Random.new

    n = r.rand(20..200)

    @random_transactions = []
    for i in (0..n)
      m = r.rand(1..5)

      for j in (0..m)
        @random_transactions[i] << items[r.rand(items.size)]
      end

    end

    @non_random = [['a', 'b'], ['b'], ['b', 'c'], ['a', 'b']]

  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  #
  def teardown
    # Do nothing
  end

  # test_scan
  def test_scan

    firstPass = FpGrowth::FpTree::Builder::FirstPass.new()
    support = firstPass.scan(@non_random)

    assert_equal(2, support['a'])
    assert_equal(4, support['b'])
    assert_equal(1, support['c'])



  end
end